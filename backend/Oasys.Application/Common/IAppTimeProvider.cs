namespace Oasys.Application.Common;

public interface IAppTimeProvider
{
    DateTime UtcNow { get; }
}
