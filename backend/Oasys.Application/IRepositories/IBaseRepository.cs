using Oasys.Core.Entities;

namespace Oasys.Application.IRepositories;

public interface IBaseRepository<TEntity, in TKey>
    where TEntity : BaseEntity
{
    IQueryable<TEntity> AsQueryable();

    Task<TEntity?> GetByIdAsync(TKey id, bool includeDeleted = false, CancellationToken cancellationToken = default);

    Task AddAsync(TEntity entity, CancellationToken cancellationToken = default);

    void Update(TEntity entity);

    Task SoftDeleteAsync(TEntity entity, CancellationToken cancellationToken = default);

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
