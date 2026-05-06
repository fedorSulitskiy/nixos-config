# Prometheus time-series database for metrics collection.
# Listens on configurable port (default 9090) and scrapes configured targets.
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.monitoring.prometheus.enable {
    services.prometheus = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = config.monitoring.prometheus.port;
      globalConfig.scrape_interval = "10s";

      # Enable remote write receiver to accept metrics from Tempo
      extraFlags = [
        "--web.enable-remote-write-receiver"
      ];
    };
  };
}
