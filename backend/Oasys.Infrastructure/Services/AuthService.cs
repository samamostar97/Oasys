using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Oasys.Application.Common;
using Oasys.Application.DTOs.Request;
using Oasys.Application.DTOs.Response;
using Oasys.Application.Exceptions;
using Oasys.Application.IServices;
using Oasys.Core.Enums;
using Oasys.Infrastructure.Configurations;

namespace Oasys.Infrastructure.Services;

public sealed class AuthService : IAuthService
{
    private readonly IAppTimeProvider _timeProvider;
    private readonly AdminCredentialsOptions _adminCredentials;
    private readonly JwtOptions _jwtOptions;

    public AuthService(
        IAppTimeProvider timeProvider,
        IOptions<AdminCredentialsOptions> adminCredentials,
        IOptions<JwtOptions> jwtOptions)
    {
        _timeProvider = timeProvider;
        _adminCredentials = adminCredentials.Value;
        _jwtOptions = jwtOptions.Value;
    }

    public Task<AuthResponse> LoginAdminAsync(AdminLoginRequest request, CancellationToken cancellationToken = default)
    {
        var username = request.Username.Trim();
        var password = request.Password;

        if (!IsAdminCredentialValid(username, password))
        {
            throw new UnauthorizedAppException("Neispravni kredencijali.");
        }

        var now = _timeProvider.UtcNow;
        var expiresAt = now.AddMinutes(_jwtOptions.AccessTokenMinutes);
        var token = GenerateToken(username, expiresAt);

        var response = new AuthResponse
        {
            Token = token,
            ExpiresAtUtc = expiresAt,
            Username = username,
            Role = nameof(AppRole.Admin)
        };

        return Task.FromResult(response);
    }

    private bool IsAdminCredentialValid(string username, string password)
    {
        if (_adminCredentials.Username.Trim().Length == 0 || _adminCredentials.Password.Length == 0)
        {
            throw new ValidationAppException("Admin kredencijali nisu konfigurirani.");
        }

        return string.Equals(_adminCredentials.Username.Trim(), username, StringComparison.OrdinalIgnoreCase)
               && string.Equals(_adminCredentials.Password, password, StringComparison.Ordinal);
    }

    private string GenerateToken(string username, DateTime expiresAt)
    {
        if (_jwtOptions.SigningKey.Length < 32)
        {
            throw new ValidationAppException("JWT signing key mora imati najmanje 32 karaktera.");
        }

        if (_jwtOptions.Issuer.Length == 0 || _jwtOptions.Audience.Length == 0)
        {
            throw new ValidationAppException("JWT issuer i audience moraju biti konfigurirani.");
        }

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, username),
            new(JwtRegisteredClaimNames.UniqueName, username),
            new(ClaimTypes.Role, nameof(AppRole.Admin))
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtOptions.SigningKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var tokenDescriptor = new JwtSecurityToken(
            issuer: _jwtOptions.Issuer,
            audience: _jwtOptions.Audience,
            claims: claims,
            expires: expiresAt,
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler().WriteToken(tokenDescriptor);
    }
}
