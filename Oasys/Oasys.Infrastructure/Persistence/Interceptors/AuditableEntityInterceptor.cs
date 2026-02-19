using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Oasys.Domain.Common;

namespace Oasys.Infrastructure.Persistence.Interceptors;

public sealed class AuditableEntityInterceptor : SaveChangesInterceptor
{
    public override InterceptionResult<int> SavingChanges(
        DbContextEventData e, InterceptionResult<int> result)
    { UpdateEntities(e.Context); return base.SavingChanges(e, result); }

    public override ValueTask<InterceptionResult<int>> SavingChangesAsync(
        DbContextEventData e, InterceptionResult<int> result, CancellationToken ct = default)
    { UpdateEntities(e.Context); return base.SavingChangesAsync(e, result, ct); }

    private static void UpdateEntities(DbContext? ctx)
    {
        if (ctx is null) return;
        foreach (var entry in ctx.ChangeTracker.Entries<BaseEntity>())
            if (entry.State == EntityState.Modified)
                entry.Entity.GetType()
                    .GetProperty(nameof(BaseEntity.UpdatedAt))
                    ?.SetValue(entry.Entity, DateTime.UtcNow);
    }
}
