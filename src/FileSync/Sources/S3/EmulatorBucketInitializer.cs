using Amazon.S3;
using Amazon.S3.Util;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace FileSync.Sources.S3;

// The emulator is in-memory, so the bucket must be created on every start.
public class EmulatorBucketInitializer(
    ILogger<EmulatorBucketInitializer> logger,
    FileSourceOptions options,
    IAmazonS3 client) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, options.Source))
                {
                    await client.PutBucketAsync(options.Source, stoppingToken);
                    logger.LogInformation("Created bucket '{Bucket}' in AWS Emulator.", options.Source);
                }
                return;
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                logger.LogWarning(ex, "AWS Emulator not ready; retrying bucket creation...");
                await Task.Delay(TimeSpan.FromSeconds(2), stoppingToken);
            }
        }
    }
}
