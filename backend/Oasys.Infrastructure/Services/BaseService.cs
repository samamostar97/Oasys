using Mapster;
using Microsoft.EntityFrameworkCore;
using Oasys.Application.Common;
using Oasys.Application.Exceptions;
using Oasys.Application.Filters;
using Oasys.Application.IRepositories;
using Oasys.Application.IServices;
using Oasys.Core.Entities;

namespace Oasys.Infrastructure.Services;

public abstract class BaseService<TEntity, TResponseDto, TCreateDto, TUpdateDto, TQueryFilter, TKey>
    : IBaseService<TResponseDto, TCreateDto, TUpdateDto, TQueryFilter, TKey>
    where TEntity : BaseEntity, new()
    where TResponseDto : class
    where TQueryFilter : BaseQueryFilter, new()
{
    private readonly IBaseRepository<TEntity, TKey> _repository;

    protected BaseService(IBaseRepository<TEntity, TKey> repository)
    {
        _repository = repository;
    }

    public virtual async Task<PagedResult<TResponseDto>> GetPagedAsync(TQueryFilter filter, CancellationToken cancellationToken = default)
    {
        var safeFilter = filter ?? new TQueryFilter();
        var query = ApplyFilter(_repository.AsQueryable(), safeFilter);

        var totalCount = await query.CountAsync(cancellationToken);
        var items = await query
            .Skip((safeFilter.PageNumber - 1) * safeFilter.PageSize)
            .Take(safeFilter.PageSize)
            .ToListAsync(cancellationToken);

        return new PagedResult<TResponseDto>(
            items.Adapt<List<TResponseDto>>(),
            totalCount,
            safeFilter.PageNumber,
            safeFilter.PageSize);
    }

    public virtual async Task<TResponseDto?> GetByIdAsync(TKey id, CancellationToken cancellationToken = default)
    {
        var entity = await _repository.GetByIdAsync(id, cancellationToken: cancellationToken);
        return entity?.Adapt<TResponseDto>();
    }

    public virtual async Task<TResponseDto> CreateAsync(TCreateDto request, CancellationToken cancellationToken = default)
    {
        var entity = request.Adapt<TEntity>();

        await BeforeCreateAsync(entity, request, cancellationToken);
        await _repository.AddAsync(entity, cancellationToken);
        await _repository.SaveChangesAsync(cancellationToken);
        await AfterCreateAsync(entity, request, cancellationToken);

        return entity.Adapt<TResponseDto>();
    }

    public virtual async Task<TResponseDto> UpdateAsync(TKey id, TUpdateDto request, CancellationToken cancellationToken = default)
    {
        var entity = await _repository.GetByIdAsync(id, cancellationToken: cancellationToken)
            ?? throw new NotFoundException($"Entity with id '{id}' was not found.");

        await BeforeUpdateAsync(entity, request, cancellationToken);
        request.Adapt(entity);
        _repository.Update(entity);
        await _repository.SaveChangesAsync(cancellationToken);
        await AfterUpdateAsync(entity, request, cancellationToken);

        return entity.Adapt<TResponseDto>();
    }

    public virtual async Task DeleteAsync(TKey id, CancellationToken cancellationToken = default)
    {
        var entity = await _repository.GetByIdAsync(id, cancellationToken: cancellationToken)
            ?? throw new NotFoundException($"Entity with id '{id}' was not found.");

        await BeforeDeleteAsync(entity, cancellationToken);
        await _repository.SoftDeleteAsync(entity, cancellationToken);
        await _repository.SaveChangesAsync(cancellationToken);
        await AfterDeleteAsync(entity, cancellationToken);
    }

    protected virtual IQueryable<TEntity> ApplyFilter(IQueryable<TEntity> query, TQueryFilter filter)
    {
        return query;
    }

    protected virtual Task BeforeCreateAsync(TEntity entity, TCreateDto request, CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterCreateAsync(TEntity entity, TCreateDto request, CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    protected virtual Task BeforeUpdateAsync(TEntity entity, TUpdateDto request, CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterUpdateAsync(TEntity entity, TUpdateDto request, CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    protected virtual Task BeforeDeleteAsync(TEntity entity, CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterDeleteAsync(TEntity entity, CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}
