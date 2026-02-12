using System.Net;

namespace Oasys.Application.Exceptions;

public sealed class ValidationAppException : AppException
{
    public ValidationAppException(string message)
        : base(message, (int)HttpStatusCode.BadRequest)
    {
    }
}
