using Microsoft.EntityFrameworkCore;
using Oasys.Application.DTOs.Request;
using Oasys.Application.DTOs.Response;
using Oasys.Application.Exceptions;
using Oasys.Application.Filters;
using Oasys.Application.IRepositories;
using Oasys.Application.IServices;
using Oasys.Core.Entities;

namespace Oasys.Infrastructure.Services;

public sealed class TrailService : BaseService<Trail, TrailResponse, CreateTrailRequest, UpdateTrailRequest, TrailQueryFilter, int>, ITrailService
{
    private readonly IBaseRepository<Trail, int> _trailRepository;

    public TrailService(IBaseRepository<Trail, int> trailRepository)
        : base(trailRepository)
    {
        _trailRepository = trailRepository;
    }

    protected override IQueryable<Trail> ApplyFilter(IQueryable<Trail> query, TrailQueryFilter filter)
    {
        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            var search = filter.Search.Trim().ToLower();
            query = query.Where(x =>
                x.Name.ToLower().Contains(search) ||
                x.Description.ToLower().Contains(search) ||
                x.City.ToLower().Contains(search));
        }

        if (!string.IsNullOrWhiteSpace(filter.City))
        {
            var city = filter.City.Trim().ToLower();
            query = query.Where(x => x.City.ToLower().Contains(city));
        }

        if (filter.Difficulty.HasValue)
        {
            query = query.Where(x => x.Difficulty == filter.Difficulty.Value);
        }

        var sortBy = filter.SortBy?.Trim().ToLowerInvariant();

        return sortBy switch
        {
            "name" => filter.SortDescending ? query.OrderByDescending(x => x.Name) : query.OrderBy(x => x.Name),
            "city" => filter.SortDescending ? query.OrderByDescending(x => x.City) : query.OrderBy(x => x.City),
            "duration" or "durationminutes" => filter.SortDescending
                ? query.OrderByDescending(x => x.DurationMinutes)
                : query.OrderBy(x => x.DurationMinutes),
            "distance" or "distancekm" => filter.SortDescending
                ? query.OrderByDescending(x => x.DistanceKm)
                : query.OrderBy(x => x.DistanceKm),
            "createdat" => filter.SortDescending ? query.OrderByDescending(x => x.CreatedAt) : query.OrderBy(x => x.CreatedAt),
            _ => query.OrderByDescending(x => x.CreatedAt)
        };
    }

    protected override async Task BeforeCreateAsync(Trail entity, CreateTrailRequest request, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
        {
            throw new ValidationAppException("Naziv je obavezan.");
        }

        if (string.IsNullOrWhiteSpace(request.City))
        {
            throw new ValidationAppException("Grad je obavezan.");
        }

        if (string.IsNullOrWhiteSpace(request.Description))
        {
            throw new ValidationAppException("Opis je obavezan.");
        }

        var normalizedName = request.Name.Trim().ToLower();
        var normalizedCity = request.City.Trim().ToLower();

        var exists = await _trailRepository.AsQueryable()
            .AnyAsync(x => x.Name.ToLower() == normalizedName && x.City.ToLower() == normalizedCity, cancellationToken);

        if (exists)
        {
            throw new ConflictException("Trail sa istim nazivom i gradom vec postoji.");
        }
    }

    protected override async Task BeforeUpdateAsync(Trail entity, UpdateTrailRequest request, CancellationToken cancellationToken)
    {
        if (request.Name is not null && string.IsNullOrWhiteSpace(request.Name))
        {
            throw new ValidationAppException("Naziv ne moze biti prazan.");
        }

        if (request.City is not null && string.IsNullOrWhiteSpace(request.City))
        {
            throw new ValidationAppException("Grad ne moze biti prazan.");
        }

        if (request.Description is not null && string.IsNullOrWhiteSpace(request.Description))
        {
            throw new ValidationAppException("Opis ne moze biti prazan.");
        }

        var finalName = (request.Name ?? entity.Name).Trim().ToLower();
        var finalCity = (request.City ?? entity.City).Trim().ToLower();

        var exists = await _trailRepository.AsQueryable()
            .AnyAsync(x => x.Id != entity.Id && x.Name.ToLower() == finalName && x.City.ToLower() == finalCity, cancellationToken);

        if (exists)
        {
            throw new ConflictException("Trail sa istim nazivom i gradom vec postoji.");
        }
    }
}
