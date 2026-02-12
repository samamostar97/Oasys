using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Oasys.Application.Common;

namespace Oasys.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class HealthController : ControllerBase
{
    private readonly IAppTimeProvider _timeProvider;

    public HealthController(IAppTimeProvider timeProvider)
    {
        _timeProvider = timeProvider;
    }

    [HttpGet]
    [AllowAnonymous]
    public IActionResult Get()
    {
        return Ok(new { status = "ok", utcNow = _timeProvider.UtcNow });
    }
}
