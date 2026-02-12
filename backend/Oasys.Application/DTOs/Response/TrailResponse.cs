using Oasys.Core.Enums;

namespace Oasys.Application.DTOs.Response;

public sealed class TrailResponse
{
    public int Id { get; init; }

    public string Name { get; init; } = string.Empty;

    public string Description { get; init; } = string.Empty;

    public string City { get; init; } = string.Empty;

    public int DurationMinutes { get; init; }

    public decimal DistanceKm { get; init; }

    public TrailDifficulty Difficulty { get; init; }

    public DateTime CreatedAt { get; init; }

    public DateTime? UpdatedAt { get; init; }
}
