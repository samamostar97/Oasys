using Microsoft.AspNetCore.Mvc;
using Oasys.Application.Features.Example.Commands.CreateExample;
using Oasys.Application.Features.Example.Queries.GetExampleById;

namespace Oasys.API.Controllers;

public sealed class ExamplesController : BaseController
{
    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id, CancellationToken ct) =>
        HandleResult(await Sender.Send(new GetExampleByIdQuery(id), ct));

    [HttpPost]
    public async Task<IActionResult> Create(CreateExampleCommand command, CancellationToken ct)
    {
        var result = await Sender.Send(command, ct);
        return result.IsSuccess
            ? CreatedAtAction(nameof(GetById), new { id = result.Value }, result.Value)
            : HandleResult(result);
    }
}
