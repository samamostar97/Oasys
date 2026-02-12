using System.Text;
using Mapster;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Oasys.Application.Common;
using Oasys.Application.IRepositories;
using Oasys.Application.IServices;
using Oasys.Infrastructure.Common;
using Oasys.Infrastructure.Configurations;
using Oasys.Infrastructure.Data;
using Oasys.Infrastructure.Mapping;
using Oasys.Infrastructure.Repositories;
using Oasys.Infrastructure.Services;

namespace Oasys.API.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApiLayer(this IServiceCollection services, IConfiguration configuration)
    {
        var jwtOptions = configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>() ?? new JwtOptions();
        var signingKey = Encoding.UTF8.GetBytes(jwtOptions.SigningKey);

        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();

        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateIssuerSigningKey = true,
                    ValidateLifetime = true,
                    ValidIssuer = jwtOptions.Issuer,
                    ValidAudience = jwtOptions.Audience,
                    IssuerSigningKey = new SymmetricSecurityKey(signingKey),
                    ClockSkew = TimeSpan.FromMinutes(1)
                };
            });

        services.AddAuthorization();

        return services;
    }

    public static IServiceCollection AddInfrastructureLayer(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<OasysDbContext>(options =>
            options.UseInMemoryDatabase("OasysDb"));

        services.Configure<JwtOptions>(configuration.GetSection(JwtOptions.SectionName));
        services.Configure<AdminCredentialsOptions>(configuration.GetSection(AdminCredentialsOptions.SectionName));

        services.AddScoped<IAppTimeProvider, DateTimeUtils>();
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ITrailService, TrailService>();
        services.AddScoped(typeof(IBaseRepository<,>), typeof(BaseRepository<,>));

        MappingConfig.Register(TypeAdapterConfig.GlobalSettings);

        return services;
    }
}
