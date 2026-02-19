using Mapster;
using MediatR;
using Oasys.Application.Common.Models;
using Oasys.Domain.Errors;
using Oasys.Domain.Repositories;

namespace Oasys.Application.Features.Example.Queries.GetExampleById;

public sealed class GetExampleByIdHandler : IRequestHandler<GetExampleByIdQuery, Result<ExampleDto>>
{
    private readonly IRepository<Domain.Entities.Example> _repo;
    public GetExampleByIdHandler(IRepository<Domain.Entities.Example> repo) => _repo = repo;

    public async Task<Result<ExampleDto>> Handle(GetExampleByIdQuery request, CancellationToken ct)
    {
        var example = await _repo.GetByIdAsync(request.Id, ct);
        if (example is null)
            return Result.Failure<ExampleDto>(
                Error.NotFound(ExampleErrors.NotFoundCode, ExampleErrors.NotFoundMessage(request.Id)));
        return Result.Success(example.Adapt<ExampleDto>());
    }
}
