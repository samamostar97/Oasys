using System.Net;

namespace Oasys.Application.Exceptions;

public sealed class ConflictException : AppException
{
    public ConflictException(string message)
        : base(message, (int)HttpStatusCode.Conflict)
    {
    }
}
