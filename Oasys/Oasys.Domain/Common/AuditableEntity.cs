namespace Oasys.Domain.Common;

public abstract class AuditableEntity : BaseEntity
{
    public string? CreatedBy  { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedAt { get; set; }
}
