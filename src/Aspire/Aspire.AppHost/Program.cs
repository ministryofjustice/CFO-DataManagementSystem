using Aspire.AppHost.Extensions;
using System.Runtime.InteropServices;
using Microsoft.Extensions.Configuration;

var builder = DistributedApplication.CreateBuilder(args);

// Parameters
var apiKey = builder.AddParameter("apiKey", true);
var isDevelopment = builder.AddParameter("isDevelopment");
var rabbitPassword = builder.AddParameter("rabbitPassword", true);
var sqlPassword = builder.AddParameter("sqlPassword", true);
var seedData = builder.Configuration.GetValue<bool>("Parameters:seedData");
var startCoreServices = builder.Configuration.GetValue<bool>("Parameters:startCoreServices");

var hostMount = HostExtensions.Create(Path.Combine(builder.AppHostDirectory, "DMS_STAGING"));
var targetMount = "/app/";

// Database setup
var sql = builder.AddDmsSqlServer(sqlPassword)
    .WithBindMount(hostMount, targetMount);

var databases = builder.AddDmsDatabases(sql, seedData);

// API setup
var apiService = builder.AddDmsApi(databases, apiKey, isDevelopment);

// Visualiser setup
builder.AddDmsVisualiser(apiService);

if (startCoreServices)
{
    var rabbit = builder
    .AddRabbitMQ("RabbitMQ", password: rabbitPassword)
    .WithManagementPlugin(port: 15672);

    // AWS Emulator (s3 emulation). State is in-memory and lost on restart.
    // Auth is off so local services need no per-run generated credentials.
    var rpmArch = RuntimeInformation.OSArchitecture == Architecture.Arm64 ? "aarch64" : "x86_64";
    var awsEmulator = builder
        .AddDockerfile("aws-emulator", Path.Combine(builder.AppHostDirectory, "AwsEmulator"))
        .WithBuildArg("RPM_ARCH", rpmArch)
        .WithArgs("-a", "off")
        .WithHttpsEndpoint(targetPort: 9297, name: "https");

    builder.AddDmsServices(
        awsEmulator,
        rabbit,
        databases,
        hostMount,
        targetMount);
}

builder.Build().Run();