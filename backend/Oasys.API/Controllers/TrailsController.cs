using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Oasys.Application.Common;
using Oasys.Application.DTOs.Request;
using Oasys.Application.DTOs.Response;
using Oasys.Application.Filters;
using Oasys.Application.IServices;
using Oasys.Core.Enums;

namespace Oasys.API.Controllers;

[ApiController]
[Route("api/trails")]
[Authorize]
public sealed class TrailsController : ControllerBase
{
    private readonly ITrailService _trailService;

    public TrailsController(ITrailService trailService)
    {
        _trailService = trailService;
    }

    [HttpGet]
    [Authorize(Roles = $"{nameof(AppRole.Admin)},{nameof(AppRole.User)}")]
    public async Task<ActionResult<PagedResult<TrailResponse>>> GetPaged(
        [FromQuery] TrailQueryFilter filter,
        CancellationToken cancellationToken)
    {
        var result = await _trailService.GetPagedAsync(filter, cancellationToken);
        return Ok(result);
    }

    [HttpGet("{id:int}")]
    [Authorize(Roles = $"{nameof(AppRole.Admin)},{nameof(AppRole.User)}")]
    public async Task<ActionResult<TrailResponse>> GetById(int id, CancellationToken cancellationToken)
    {
        var item = await _trailService.GetByIdAsync(id, cancellationToken);
        if (item is null)
        {
            return NotFound(new { message = $"Trail sa id '{id}' nije pronadjen." });
        }

        return Ok(item);
    }

    [HttpPost]
    [Authorize(Roles = nameof(AppRole.Admin))]
    public async Task<ActionResult<TrailResponse>> Create(
        [FromBody] CreateTrailRequest request,
        CancellationToken cancellationToken)
    {
        var created = await _trailService.CreateAsync(request, cancellationToken);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id:int}")]
    [Authorize(Roles = nameof(AppRole.Admin))]
    public async Task<ActionResult<TrailResponse>> Update(
        int id,
        [FromBody] UpdateTrailRequest request,
        CancellationToken cancellationToken)
    {
        var updated = await _trailService.UpdateAsync(id, request, cancellationToken);
        return Ok(updated);
    }

    [HttpDelete("{id:int}")]
    [Authorize(Roles = nameof(AppRole.Admin))]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
    {
        await _trailService.DeleteAsync(id, cancellationToken);
        return NoContent();
    }
}
