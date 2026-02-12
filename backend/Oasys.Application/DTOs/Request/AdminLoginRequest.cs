using System.ComponentModel.DataAnnotations;

namespace Oasys.Application.DTOs.Request;

public sealed class AdminLoginRequest
{
    [Required(ErrorMessage = "Korisnicko ime je obavezno.")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Korisnicko ime mora imati izmedu 3 i 100 karaktera.")]
    public string Username { get; set; } = string.Empty;

    [Required(ErrorMessage = "Lozinka je obavezna.")]
    [StringLength(200, MinimumLength = 4, ErrorMessage = "Lozinka mora imati izmedu 4 i 200 karaktera.")]
    public string Password { get; set; } = string.Empty;
}
