namespace Oasys.Domain.Errors;

public static class ExampleErrors
{
    public static readonly string NotFoundCode = "Example.NotFound";
    public static string NotFoundMessage(Guid id) => $"Example with id '{id}' was not found.";

    public static readonly string TitleRequiredCode    = "Example.TitleRequired";
    public static readonly string TitleRequiredMessage = "Title is required.";
}
