using Oasys.Worker.Services;

var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddHostedService<HeartbeatService>();
    })
    .Build();

host.Run();
