using Oasys.Domain.Common;
using Oasys.Domain.Events;

namespace Oasys.Domain.Entities;

public sealed class Example : AuditableEntity
{
    public string Title       { get; private set; } = string.Empty;
    public string Description { get; private set; } = string.Empty;
    public bool   IsActive    { get; private set; }

    private Example() { }

    public static Example Create(string title, string description)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(title);
        var e = new Example { Title = title, Description = description, IsActive = true };
        e.AddDomainEvent(new ExampleCreatedEvent(e.Id, title));
        return e;
    }

    public void Update(string title, string description)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(title);
        Title = title; Description = description; UpdatedAt = DateTime.UtcNow;
    }

    public void Deactivate() => IsActive = false;
}
