using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Oasys.Application.Common.Interfaces;
using Oasys.Domain.Entities;
using Oasys.Domain.Repositories;
using Oasys.Infrastructure.Auth;
using Oasys.Infrastructure.Persistence;
using Oasys.Infrastructure.Persistence.Interceptors;
using Oasys.Infrastructure.Persistence.Repositories;
using Oasys.Infrastructure.Services;

namespace Oasys.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton<AuditableEntityInterceptor>();

        services.AddDbContext<AppDbContext>((sp, options) =>
            options.UseSqlServer(
                configuration.GetConnectionString("DefaultConnection"),
                b => b.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
            .AddInterceptors(sp.GetRequiredService<AuditableEntityInterceptor>()));

        services.AddScoped<IUnitOfWork>(sp => sp.GetRequiredService<AppDbContext>());
        services.AddScoped<IRepository<Example>, Repository<Example>>();

        services.AddHttpContextAccessor();
        services.AddScoped<ICurrentUserService, CurrentUserService>();
        services.AddScoped<IEmailService, EmailService>();
        services.AddScoped<JwtTokenGenerator>();

        return services;
    }
}
