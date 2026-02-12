using Microsoft.EntityFrameworkCore;
using Oasys.Application.IRepositories;
using Oasys.Core.Entities;
using Oasys.Infrastructure.Data;

namespace Oasys.Infrastructure.Repositories;

public class BaseRepository<TEntity, TKey> : IBaseRepository<TEntity, TKey>
    where TEntity : BaseEntity
{
    private readonly OasysDbContext _dbContext;
    private readonly DbSet<TEntity> _dbSet;

    public BaseRepository(OasysDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<TEntity>();
    }

    public IQueryable<TEntity> AsQueryable()
    {
        return _dbSet.Where(x => !x.IsDeleted);
    }

    public async Task<TEntity?> GetByIdAsync(TKey id, bool includeDeleted = false, CancellationToken cancellationToken = default)
    {
        var entity = await _dbSet.FindAsync([id], cancellationToken);
        if (entity is null)
        {
            return null;
        }

        if (!includeDeleted && entity.IsDeleted)
        {
            return null;
        }

        return entity;
    }

    public Task AddAsync(TEntity entity, CancellationToken cancellationToken = default)
    {
        return _dbSet.AddAsync(entity, cancellationToken).AsTask();
    }

    public void Update(TEntity entity)
    {
        _dbSet.Update(entity);
    }

    public Task SoftDeleteAsync(TEntity entity, CancellationToken cancellationToken = default)
    {
        entity.IsDeleted = true;
        _dbSet.Update(entity);
        return Task.CompletedTask;
    }

    public Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        return _dbContext.SaveChangesAsync(cancellationToken);
    }
}
