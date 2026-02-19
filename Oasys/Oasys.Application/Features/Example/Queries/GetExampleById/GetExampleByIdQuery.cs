using MediatR;
using Oasys.Application.Common.Models;

namespace Oasys.Application.Features.Example.Queries.GetExampleById;

public sealed record GetExampleByIdQuery(Guid Id) : IRequest<Result<ExampleDto>>;
