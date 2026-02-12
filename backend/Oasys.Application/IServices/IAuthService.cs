using Oasys.Application.DTOs.Request;
using Oasys.Application.DTOs.Response;

namespace Oasys.Application.IServices;

public interface IAuthService
{
    Task<AuthResponse> LoginAdminAsync(AdminLoginRequest request, CancellationToken cancellationToken = default);
}
