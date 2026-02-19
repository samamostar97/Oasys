using System.Reflection;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Oasys.Application.Common.Interfaces;
using Oasys.Domain.Common;
using Oasys.Domain.Entities;

namespace Oasys.Infrastructure.Persistence;

public sealed class AppDbContext : DbContext, IUnitOfWork
{
    private readonly IPublisher _publisher;
    private readonly ICurrentUserService _currentUser;

    public AppDbContext(
        DbContextOptions<AppDbContext> options,
        IPublisher publisher,
        ICurrentUserService currentUser) : base(options)
    {
        _publisher   = publisher;
        _currentUser = currentUser;
    }

    public DbSet<Example> Examples => Set<Example>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
        base.OnModelCreating(builder);
    }

    public override async Task<int> SaveChangesAsync(CancellationToken ct = default)
    {
        foreach (var entry in ChangeTracker.Entries<AuditableEntity>())
        {
            if (entry.State == EntityState.Added)
                entry.Entity.CreatedBy = _currentUser.Email;
            else if (entry.State == EntityState.Modified)
            {
                entry.Entity.ModifiedBy = _currentUser.Email;
                entry.Entity.ModifiedAt = DateTime.UtcNow;
            }
        }

        var result   = await base.SaveChangesAsync(ct);
        var entities = ChangeTracker.Entries<BaseEntity>()
            .Where(e => e.Entity.DomainEvents.Any())
            .Select(e => e.Entity).ToList();
        var events = entities.SelectMany(e => e.DomainEvents).ToList();
        entities.ForEach(e => e.ClearDomainEvents());
        foreach (var ev in events) await _publisher.Publish(ev, ct);
        return result;
    }
}
