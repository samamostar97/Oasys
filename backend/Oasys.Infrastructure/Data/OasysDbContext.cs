using Microsoft.EntityFrameworkCore;
using Oasys.Application.Common;
using Oasys.Core.Entities;

namespace Oasys.Infrastructure.Data;

public sealed class OasysDbContext : DbContext
{
    private readonly IAppTimeProvider _timeProvider;

    public OasysDbContext(DbContextOptions<OasysDbContext> options, IAppTimeProvider timeProvider)
        : base(options)
    {
        _timeProvider = timeProvider;
    }

    public DbSet<Trail> Trails => Set<Trail>();

    public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        foreach (var entry in ChangeTracker.Entries<BaseEntity>())
        {
            if (entry.State == EntityState.Added)
            {
                entry.Entity.CreatedAt = _timeProvider.UtcNow;
                entry.Entity.IsDeleted = false;
            }

            if (entry.State == EntityState.Modified)
            {
                entry.Entity.UpdatedAt = _timeProvider.UtcNow;
            }
        }

        return base.SaveChangesAsync(cancellationToken);
    }
}
