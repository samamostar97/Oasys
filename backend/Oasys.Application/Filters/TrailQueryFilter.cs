using Oasys.Core.Enums;

namespace Oasys.Application.Filters;

public sealed class TrailQueryFilter : BaseQueryFilter
{
    public string? City { get; set; }

    public TrailDifficulty? Difficulty { get; set; }
}
