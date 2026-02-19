using MediatR;
using Microsoft.AspNetCore.Mvc;
using Oasys.Application.Common.Models;

namespace Oasys.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public abstract class BaseController : ControllerBase
{
    private ISender? _sender;
    protected ISender Sender =>
        _sender ??= HttpContext.RequestServices.GetRequiredService<ISender>();

    protected IActionResult HandleResult<T>(Result<T> result) =>
        result.IsSuccess ? Ok(result.Value) : ToActionResult(result.Error);

    protected IActionResult HandleResult(Result result) =>
        result.IsSuccess ? Ok() : ToActionResult(result.Error);

    private IActionResult ToActionResult(Error error) => error.Type switch
    {
        ErrorType.NotFound     => NotFound(new     { error.Code, error.Description }),
        ErrorType.Validation   => BadRequest(new   { error.Code, error.Description }),
        ErrorType.Conflict     => Conflict(new     { error.Code, error.Description }),
        ErrorType.Unauthorized => Unauthorized(new { error.Code, error.Description }),
        _                      => StatusCode(500,  new { error.Code, error.Description })
    };
}
