using System.Net;

namespace Oasys.Application.Exceptions;

public sealed class UnauthorizedAppException : AppException
{
    public UnauthorizedAppException(string message)
        : base(message, (int)HttpStatusCode.Unauthorized)
    {
    }
}
