namespace Oasys.Application.Features.Example.Queries.GetExampleById;

public sealed record ExampleDto(
    Guid     Id,
    string   Title,
    string   Description,
    bool     IsActive,
    DateTime CreatedAt);
