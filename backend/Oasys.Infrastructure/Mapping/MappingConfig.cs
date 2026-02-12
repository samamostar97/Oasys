using Mapster;
using Oasys.Application.DTOs.Request;
using Oasys.Core.Entities;

namespace Oasys.Infrastructure.Mapping;

public static class MappingConfig
{
    public static void Register(TypeAdapterConfig config)
    {
        config.Default.NameMatchingStrategy(NameMatchingStrategy.Flexible);

        config.NewConfig<UpdateTrailRequest, Trail>()
            .IgnoreNullValues(true);
    }
}
