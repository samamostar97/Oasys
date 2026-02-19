using MediatR;

namespace Oasys.Domain.Common;

public interface IDomainEvent : INotification
{
    DateTime OccurredAt { get; }
}
