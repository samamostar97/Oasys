namespace Oasys.Application.DTOs.Response;

public sealed class AuthResponse
{
    public required string Token { get; init; }

    public required DateTime ExpiresAtUtc { get; init; }

    public required string Username { get; init; }

    public required string Role { get; init; }
}
