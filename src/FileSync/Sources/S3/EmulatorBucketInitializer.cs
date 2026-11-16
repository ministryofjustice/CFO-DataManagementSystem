using Amazon.S3;
using Amazon.S3.Transfer;
using Amazon.S3.Model;
using Amazon.S3.Util;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace FileSync.Sources.S3;

// The emulator is in-memory, so the bucket must be created on every start.
public class EmulatorBucketInitializer(
    ILogger<EmulatorBucketInitializer> logger,
    FileSourceOptions options,
    IConfiguration configuration,
    IAmazonS3 client) : IHostedService
{
    private readonly HashSet<string> seeded = [];
    private readonly CancellationTokenSource cts = new();
    private Task? watcher;

    // Blocks host startup until the bucket exists; seeding runs in the background.
    public async Task StartAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, options.Source))
                {
                    // Explicit us-east-1 stops the SDK adding the ambient region (e.g. eu-west-2) as a LocationConstraint.
                    // Don't set RegionEndpoint on the client instead: it overrides ServiceURL and hits real AWS.
                    await client.PutBucketAsync(new PutBucketRequest
                    {
                        BucketName = options.Source,
                        BucketRegion = S3Region.USEast1
                    }, stoppingToken);
                    logger.LogInformation("Created bucket '{Bucket}' in AWS Emulator.", options.Source);
                }

                watcher = Task.Run(() => WatchAsync(cts.Token), CancellationToken.None);
                return;
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                logger.LogWarning(ex, "AWS Emulator not ready; retrying bucket creation...");
                await Task.Delay(TimeSpan.FromSeconds(2), stoppingToken);
            }
        }
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        await cts.CancelAsync();
        if (watcher is not null)
        {
            await watcher.WaitAsync(cancellationToken).ConfigureAwait(false);
        }
    }

    private async Task SeedAsync(CancellationToken cancellationToken)
    {
        var seedPath = configuration.GetValue<string>("AwsEmulator:SeedPath");
        if (string.IsNullOrEmpty(seedPath) || !Directory.Exists(seedPath))
        {
            return;
        }

        using var transfer = new TransferUtility(client);

        foreach (var file in Directory.EnumerateFiles(seedPath, "*", SearchOption.AllDirectories))
        {
            var key = Path.GetRelativePath(seedPath, file).Replace('\\', '/');
            var info = new FileInfo(file);
            if (key.StartsWith('.') || DateTime.UtcNow - info.LastWriteTimeUtc < TimeSpan.FromSeconds(5) || !seeded.Add($"{key}|{info.Length}|{info.LastWriteTimeUtc.Ticks}"))
            {
                continue;
            }

            try
            {
                logger.LogInformation("Seeding '{Key}' ({Size:N0} bytes) into bucket '{Bucket}'...", key, info.Length, options.Source);
                await transfer.UploadAsync(file, options.Source, key, cancellationToken);
                logger.LogInformation("Seeded '{Key}' into bucket '{Bucket}'.", key, options.Source);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                seeded.Remove($"{key}|{info.Length}|{info.LastWriteTimeUtc.Ticks}");
                logger.LogWarning(ex, "Failed to seed '{Key}'; will retry.", key);
            }
        }
    }

    // Picks up files dropped into the seed folder after startup (ignoring ones still being written).
    private async Task WatchAsync(CancellationToken cancellationToken)
    {
        try
        {
            using var timer = new PeriodicTimer(TimeSpan.FromSeconds(10));
            do
            {
                await SeedAsync(cancellationToken);
            }
            while (await timer.WaitForNextTickAsync(cancellationToken));
        }
        catch (OperationCanceledException)
        {
        }
    }
}
