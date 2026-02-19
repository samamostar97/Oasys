using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Oasys.Domain.Entities;

namespace Oasys.Infrastructure.Persistence.Configurations;

public sealed class ExampleConfiguration : BaseEntityConfiguration<Example>
{
    public override void Configure(EntityTypeBuilder<Example> builder)
    {
        base.Configure(builder);
        builder.ToTable("Examples");
        builder.Property(e => e.Title).IsRequired().HasMaxLength(200);
        builder.Property(e => e.Description).HasMaxLength(2000);
        builder.Property(e => e.IsActive).IsRequired();
    }
}
