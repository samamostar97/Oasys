using Oasys.Application.Common;

namespace Oasys.Infrastructure.Common;

public sealed class DateTimeUtils : IAppTimeProvider
{
    public DateTime UtcNow => DateTime.UtcNow;
}
