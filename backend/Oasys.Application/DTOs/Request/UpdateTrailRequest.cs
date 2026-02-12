using System.ComponentModel.DataAnnotations;
using Oasys.Core.Enums;

namespace Oasys.Application.DTOs.Request;

public sealed class UpdateTrailRequest
{
    [StringLength(120, MinimumLength = 2, ErrorMessage = "Naziv mora imati izmedu 2 i 120 karaktera.")]
    public string? Name { get; set; }

    [StringLength(2000, MinimumLength = 10, ErrorMessage = "Opis mora imati izmedu 10 i 2000 karaktera.")]
    public string? Description { get; set; }

    [StringLength(120, MinimumLength = 2, ErrorMessage = "Grad mora imati izmedu 2 i 120 karaktera.")]
    public string? City { get; set; }

    [Range(1, 10080, ErrorMessage = "Trajanje mora biti izmedu 1 i 10080 minuta.")]
    public int? DurationMinutes { get; set; }

    [Range(typeof(decimal), "0.1", "1000", ErrorMessage = "Duzina mora biti izmedu 0.1 i 1000 kilometara.")]
    public decimal? DistanceKm { get; set; }

    public TrailDifficulty? Difficulty { get; set; }
}
