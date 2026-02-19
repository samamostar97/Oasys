namespace Oasys.Application.Common.Models;

public sealed class Result
{
    public bool  IsSuccess { get; }
    public bool  IsFailure => !IsSuccess;
    public Error Error     { get; }

    private Result(bool ok, Error err) { IsSuccess = ok; Error = err; }

    public static Result    Success()             => new(true,  Error.None);
    public static Result    Failure(Error err)    => new(false, err);
    public static Result<T> Success<T>(T value)   => new(value, true,  Error.None);
    public static Result<T> Failure<T>(Error err) => new(default, false, err);
}

public sealed class Result<T>
{
    public bool  IsSuccess { get; }
    public bool  IsFailure => !IsSuccess;
    public T?    Value     { get; }
    public Error Error     { get; }

    internal Result(T? value, bool ok, Error err)
    { Value = value; IsSuccess = ok; Error = err; }
}

public sealed record Error(string Code, string Description, ErrorType Type)
{
    public static readonly Error None = new(string.Empty, string.Empty, ErrorType.None);

    public static Error NotFound    (string code, string desc) => new(code, desc, ErrorType.NotFound);
    public static Error Validation  (string code, string desc) => new(code, desc, ErrorType.Validation);
    public static Error Conflict    (string code, string desc) => new(code, desc, ErrorType.Conflict);
    public static Error Failure     (string code, string desc) => new(code, desc, ErrorType.Failure);
    public static Error Unauthorized(string code, string desc) => new(code, desc, ErrorType.Unauthorized);
}

public enum ErrorType { None, NotFound, Validation, Conflict, Failure, Unauthorized }
