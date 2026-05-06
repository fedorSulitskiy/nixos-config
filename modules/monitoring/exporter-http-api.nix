# Scrape Prometheus metrics from local HTTP API instances.
# Each API must expose a /metrics endpoint (or custom metricsPath).
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.monitoring.httpApi != []) {
    services.prometheus.scrapeConfigs =
      map (api: {
        job_name = api.name;
        metrics_path = api.metricsPath;
        scrape_interval = api.scrapeInterval;
        static_configs = [
          {
            targets = ["localhost:${toString api.port}"];
          }
        ];
      })
      config.monitoring.httpApi;
  };
}
