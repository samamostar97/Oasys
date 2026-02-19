using Oasys.Domain.Common;

namespace Oasys.Domain.Events;

public sealed record ExampleCreatedEvent(Guid ExampleId, string Title) : IDomainEvent
{
    public DateTime OccurredAt { get; } = DateTime.UtcNow;
}
