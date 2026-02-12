namespace Oasys.Messaging.Messages;

public record EntityChangedMessage(
    string EntityName,
    int EntityId,
    string Action,
    DateTime OccurredAtUtc);
