using Messaging.Extensions;

try
{
    var builder = Host.CreateApplicationBuilder(args);

    builder.AddDmsCoreWorkerService();
    builder.Services.AddDmsRabbitMQ(builder.Configuration);

    builder.Services.AddOptions<SyncOptions>().BindConfiguration("SyncOptions");

    var source = builder.Configuration.GetValue<string>("FileSourceProvider")?.ToLowerInvariant();

    if (source == "s3")
    {
        builder.Services.AddDefaultAWSOptions(builder.Configuration.GetAWSOptions());
        builder.Services.AddAWSService<IAmazonS3>();
        builder.Services.AddSingleton<FileSource, S3FileSource>();
        builder.Services.AddSingleton(sp => new FileSourceOptions(builder.Configuration.GetValue<string>("AWS:S3:BucketName")!));
    }
    else if (source == "filesystem")
    {
        builder.Services.AddSingleton<FileSource, SystemFileSource>();
        builder.Services.AddSingleton(sp => new FileSourceOptions(builder.Configuration.GetValue<string>("FileSystem:SourceLocation")!));
    }
    else if (source == "awsemulator")
    {
        // Local development only: the emulator serves HTTPS with a per-run self-signed certificate and auth is off.
        builder.Services.AddSingleton<IAmazonS3>(_ => new AmazonS3Client(
            new Amazon.Runtime.BasicAWSCredentials("emulator", "emulator"),
            new AmazonS3Config
            {
                ServiceURL = builder.Configuration.GetValue<string>("AwsEmulator:ServiceUrl")!,
                ForcePathStyle = true,
                AuthenticationRegion = "us-east-1",
                HttpClientFactory = new InsecureHttpClientFactory()
            }));
        builder.Services.AddSingleton<FileSource, S3FileSource>();
        builder.Services.AddSingleton(sp => new FileSourceOptions(builder.Configuration.GetValue<string>("AwsEmulator:BucketName")!));
        builder.Services.AddHostedService<EmulatorBucketInitializer>();
    }
    else
    {
        throw new InvalidOperationException("Set 'FileSourceProvider' to 'S3', 'FileSystem', or 'AwsEmulator' in configuration.");
    }

    builder.Services.AddHostedService<FileSyncBackgroundService>();

    var app = builder.Build();
    Log.Information("Starting application");
    app.Run();

    return 0;
}
catch (Exception ex)
{
    Log.Fatal(ex, "Host terminated unexpectedly");
    return 1;
}
finally
{
    Log.Information("Application stopping");
    await Log.CloseAndFlushAsync();
}
