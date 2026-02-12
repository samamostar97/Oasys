using Oasys.Application.Common;

namespace Oasys.Application.IServices;

public interface IBaseService<TResponseDto, in TCreateDto, in TUpdateDto, in TQueryFilter, in TKey>
    where TQueryFilter : PaginationRequest
    where TResponseDto : class
{
    Task<PagedResult<TResponseDto>> GetPagedAsync(TQueryFilter filter, CancellationToken cancellationToken = default);

    Task<TResponseDto?> GetByIdAsync(TKey id, CancellationToken cancellationToken = default);

    Task<TResponseDto> CreateAsync(TCreateDto request, CancellationToken cancellationToken = default);

    Task<TResponseDto> UpdateAsync(TKey id, TUpdateDto request, CancellationToken cancellationToken = default);

    Task DeleteAsync(TKey id, CancellationToken cancellationToken = default);
}
