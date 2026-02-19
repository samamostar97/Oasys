using MediatR;
using Oasys.Application.Common.Interfaces;
using Oasys.Application.Common.Models;
using Oasys.Domain.Repositories;

namespace Oasys.Application.Features.Example.Commands.CreateExample;

public sealed class CreateExampleHandler : IRequestHandler<CreateExampleCommand, Result<Guid>>
{
    private readonly IRepository<Domain.Entities.Example> _repo;
    private readonly IUnitOfWork _uow;

    public CreateExampleHandler(IRepository<Domain.Entities.Example> repo, IUnitOfWork uow)
    { _repo = repo; _uow = uow; }

    public async Task<Result<Guid>> Handle(CreateExampleCommand request, CancellationToken ct)
    {
        var example = Domain.Entities.Example.Create(request.Title, request.Description);
        await _repo.AddAsync(example, ct);
        await _uow.SaveChangesAsync(ct);
        return Result.Success(example.Id);
    }
}
