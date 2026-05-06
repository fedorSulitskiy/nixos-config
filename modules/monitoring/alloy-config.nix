# Unified Grafana Alloy configuration module.
# Manages a single alloy config file that handles both Loki logs and Tempo traces.
# This prevents port conflicts by using a shared OTLP receiver.
{
  config,
  lib,
  ...
}: let
  # Determine which features are enabled
  lokiEnabled = config.monitoring.lokiClient.enable;
  tempoEnabled = config.monitoring.tempoServer.enable;

  # Only enable alloy if either lokiClient or tempoServer is enabled
  alloyEnabled = lokiEnabled || tempoEnabled;
in {
  config = lib.mkIf alloyEnabled {
    services.alloy = {
      enable = true;
      extraFlags = [
        "--server.http.listen-addr=127.0.0.1:9080"
        "--disable-reporting"
      ];
    };

    # Write the unified alloy configuration with substituted values
    environment.etc."alloy/config.alloy" = {
      text =
        builtins.replaceStrings
        ["@JOB_NAME@" "@SERVER_ADDRESS@" "@SERVER_PORT@"]
        [
          (
            if lokiEnabled
            then config.monitoring.lokiClient.jobName
            else "default"
          )
          (
            if lokiEnabled
            then config.monitoring.lokiClient.serverAddress
            else "localhost"
          )
          (
            if lokiEnabled
            then toString config.monitoring.lokiClient.serverPort
            else "3100"
          )
        ]
        (builtins.readFile ./alloy/config.alloy);
    };
  };
}
