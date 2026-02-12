using Oasys.Core.Enums;

namespace Oasys.Core.Entities;

public sealed class Trail : BaseEntity
{
    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    public string City { get; set; } = string.Empty;

    public int DurationMinutes { get; set; }

    public decimal DistanceKm { get; set; }

    public TrailDifficulty Difficulty { get; set; }
}
