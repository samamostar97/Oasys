using Microsoft.EntityFrameworkCore;
using Oasys.Domain.Common;
using Oasys.Domain.Repositories;

namespace Oasys.Infrastructure.Persistence.Repositories;

public class Repository<T> : IRepository<T> where T : BaseEntity
{
    protected readonly AppDbContext Db;
    protected readonly DbSet<T> DbSet;

    public Repository(AppDbContext db) { Db = db; DbSet = db.Set<T>(); }

    public async Task<T?> GetByIdAsync(Guid id, CancellationToken ct = default) =>
        await DbSet.FirstOrDefaultAsync(e => e.Id == id, ct);

    public async Task<IEnumerable<T>> GetAllAsync(CancellationToken ct = default) =>
        await DbSet.ToListAsync(ct);

    public async Task AddAsync(T entity, CancellationToken ct = default) =>
        await DbSet.AddAsync(entity, ct);

    public void Update(T entity) => DbSet.Update(entity);
    public void Delete(T entity) => DbSet.Remove(entity);
}
