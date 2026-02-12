using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Oasys.Application.DTOs.Request;
using Oasys.Application.DTOs.Response;
using Oasys.Application.IServices;

namespace Oasys.API.Controllers;

[ApiController]
[Route("api/auth")]
public sealed class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("login/admin")]
    [AllowAnonymous]
    public async Task<ActionResult<AuthResponse>> LoginAdmin(
        [FromBody] AdminLoginRequest request,
        CancellationToken cancellationToken)
    {
        var response = await _authService.LoginAdminAsync(request, cancellationToken);
        return Ok(response);
    }
}
