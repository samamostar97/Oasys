using System.Net;

namespace Oasys.Application.Exceptions;

public sealed class NotFoundException : AppException
{
    public NotFoundException(string message)
        : base(message, (int)HttpStatusCode.NotFound)
    {
    }
}
