using Oasys.API.Extensions;
using Oasys.API.Middleware;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddApiLayer(builder.Configuration)
    .AddInfrastructureLayer(builder.Configuration);

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseMiddleware<ExceptionHandlerMiddleware>();
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
