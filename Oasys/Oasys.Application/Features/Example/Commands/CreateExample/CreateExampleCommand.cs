using MediatR;
using Oasys.Application.Common.Models;

namespace Oasys.Application.Features.Example.Commands.CreateExample;

public sealed record CreateExampleCommand(string Title, string Description)
    : IRequest<Result<Guid>>;
