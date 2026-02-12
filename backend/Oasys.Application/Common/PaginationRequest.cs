namespace Oasys.Application.Common;

public class PaginationRequest
{
    private const int MaxPageSize = 100;
    private const int DefaultPageSize = 20;

    private int _pageSize = DefaultPageSize;

    public int PageNumber { get; set; } = 1;

    public int PageSize
    {
        get => _pageSize;
        set => _pageSize = value <= 0 ? DefaultPageSize : Math.Min(value, MaxPageSize);
    }
}
