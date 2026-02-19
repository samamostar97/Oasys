using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Oasys.Application.Common.Interfaces;

namespace Oasys.Infrastructure.Services;

public sealed class CurrentUserService : ICurrentUserService
{
    private readonly IHttpContextAccessor _http;
    public CurrentUserService(IHttpContextAccessor http) => _http = http;

    private ClaimsPrincipal? User => _http.HttpContext?.User;

    public Guid UserId =>
        Guid.TryParse(User?.FindFirst(ClaimTypes.NameIdentifier)?.Value, out var id)
            ? id : Guid.Empty;

    public string Email           => User?.FindFirst(ClaimTypes.Email)?.Value ?? string.Empty;
    public string Role            => User?.FindFirst(ClaimTypes.Role)?.Value  ?? string.Empty;
    public bool   IsAuthenticated => User?.Identity?.IsAuthenticated          ?? false;
}
