namespace Oasys.Infrastructure.Configurations;

public sealed class AdminCredentialsOptions
{
    public const string SectionName = "Auth:Admin";

    public string Username { get; set; } = string.Empty;

    public string Password { get; set; } = string.Empty;
}
