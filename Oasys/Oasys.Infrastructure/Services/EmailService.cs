using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Oasys.Application.Common.Interfaces;

namespace Oasys.Infrastructure.Services;

public sealed class EmailService : IEmailService
{
    private readonly IConfiguration _config;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IConfiguration config, ILogger<EmailService> logger)
    { _config = config; _logger = logger; }

    public async Task SendAsync(string to, string subject, string body, CancellationToken ct = default)
    {
        try
        {
            var msg = new MimeMessage();
            msg.From.Add(MailboxAddress.Parse(_config["Email:From"]));
            msg.To.Add(MailboxAddress.Parse(to));
            msg.Subject = subject;
            msg.Body    = new TextPart("html") { Text = body };

            using var client = new SmtpClient();
            await client.ConnectAsync(_config["Email:Host"],
                int.Parse(_config["Email:Port"] ?? "587"), false, ct);
            await client.AuthenticateAsync(_config["Email:Username"], _config["Email:Password"], ct);
            await client.SendAsync(msg, ct);
            await client.DisconnectAsync(true, ct);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {To}", to);
            throw;
        }
    }
}
