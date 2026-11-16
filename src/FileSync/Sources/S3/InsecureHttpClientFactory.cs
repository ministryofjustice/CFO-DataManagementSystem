using Amazon.Runtime;

namespace FileSync.Sources.S3;

// Accepts the AWS Emulator's self-signed certificate. Never use outside local development.
public class InsecureHttpClientFactory : HttpClientFactory
{
    public override HttpClient CreateHttpClient(IClientConfig clientConfig) =>
        new(new HttpClientHandler
        {
            ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
        });
}
