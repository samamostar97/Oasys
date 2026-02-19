using System.Net;
using System.Text.Json;
using Oasys.Application.Common.Exceptions;

namespace Oasys.API.Middleware;

public sealed class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;

    public ExceptionHandlingMiddleware(RequestDelegate next,
        ILogger<ExceptionHandlingMiddleware> logger)
    { _next = next; _logger = logger; }

    public async Task InvokeAsync(HttpContext ctx)
    {
        try { await _next(ctx); }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled: {Message}", ex.Message);
            await Handle(ctx, ex);
        }
    }

    private static async Task Handle(HttpContext ctx, Exception ex)
    {
        var (status, errors) = ex switch
        {
            ValidationException ve => (HttpStatusCode.BadRequest, ve.Errors),
            NotFoundException      => (HttpStatusCode.NotFound,
                new Dictionary<string, string[]> { ["error"] = new[] { ex.Message } }),
            _                      => (HttpStatusCode.InternalServerError,
                new Dictionary<string, string[]> { ["error"] = new[] { "An unexpected error occurred." } })
        };
        ctx.Response.ContentType = "application/json";
        ctx.Response.StatusCode  = (int)status;
        await ctx.Response.WriteAsync(
            JsonSerializer.Serialize(new { errors }), ctx.RequestAborted);
    }
}
