using FluentValidation;

namespace Oasys.Application.Features.Example.Commands.CreateExample;

public sealed class CreateExampleValidator : AbstractValidator<CreateExampleCommand>
{
    public CreateExampleValidator()
    {
        RuleFor(x => x.Title)
            .NotEmpty().WithMessage("Title is required.")
            .MaximumLength(200);
    }
}
