using Oasys.Application.DTOs.Request;
using Oasys.Application.DTOs.Response;
using Oasys.Application.Filters;

namespace Oasys.Application.IServices;

public interface ITrailService : IBaseService<TrailResponse, CreateTrailRequest, UpdateTrailRequest, TrailQueryFilter, int>
{
}
