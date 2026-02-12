using Oasys.Application.Common;

namespace Oasys.Application.Filters;

public class BaseQueryFilter : PaginationRequest
{
    public string? Search { get; set; }

    public string? SortBy { get; set; }

    public bool SortDescending { get; set; }
}
