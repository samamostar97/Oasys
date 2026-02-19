using MediatR;
using Microsoft.Extensions.Logging;
using Oasys.Domain.Events;

namespace Oasys.Application.Features.Example.EventHandlers;

public sealed class ExampleCreatedEventHandler : INotificationHandler<ExampleCreatedEvent>
{
    private readonly ILogger<ExampleCreatedEventHandler> _logger;
    public ExampleCreatedEventHandler(ILogger<ExampleCreatedEventHandler> l) => _logger = l;

    public Task Handle(ExampleCreatedEvent n, CancellationToken ct)
    {
        _logger.LogInformation("Example created: {Id} - {Title}", n.ExampleId, n.Title);
        return Task.CompletedTask;
    }
}
