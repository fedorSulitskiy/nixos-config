# Grafana dashboard for metrics visualization.
# Connects to Prometheus (default) and Loki data sources.
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Auto-discover every *.json file under ./dashboards/ and collect them into
  # a single directory in the Nix store for Grafana's file-based provisioning.
  dashboardsDir = pkgs.linkFarm "grafana-dashboards" (
    lib.mapAttrsToList
    (name: _: {
      inherit name;
      path = ./dashboards + "/${name}";
    })
    (
      lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".json" name) (
        builtins.readDir ./dashboards
      )
    )
  );
in {
  config = lib.mkIf config.monitoring.grafana.enable {
    services.grafana = {
      enable = true;
      # Drilldown app plugins (Grafana 12): adds "Logs", "Metrics", "Traces",
      # and "Profiles" cards to the Drilldown page.
      declarativePlugins = with pkgs.grafanaPlugins; [
        grafana-lokiexplore-app
        grafana-metricsdrilldown-app
        grafana-exploretraces-app
        grafana-pyroscope-app
      ];
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          enforce_domain = false;
          enable_gzip = true;
        };
        security = {
          admin_user = "admin";
          # Use env-var provider instead of literal values to avoid the
          # "plaintext in Nix store" evaluation warning.
          admin_password = "$__env{GF_SECURITY_ADMIN_PASSWORD}";
          secret_key = "$__env{GF_SECURITY_SECRET_KEY}";
        };
        analytics.reporting_enabled = false;
      };
      provision = {
        enable = true;
        dashboards.settings.providers = [
          {
            name = "provisioned-dashboards";
            # Disallow UI deletion/editing: dashboards are managed via Nix.
            disableDeletion = true;
            editable = false;
            # Serve dashboards directly from the Nix store
            # (auto-updated on each nixos-rebuild).
            options = {
              path = dashboardsDir;
              foldersFromFilesStructure = true;
            };
          }
        ];
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://localhost:${toString config.monitoring.prometheus.port}";
            access = "proxy";
            isDefault = true;
          }
          {
            name = "Loki";
            type = "loki";
            url = "http://localhost:${toString config.monitoring.lokiServer.port}";
            access = "proxy";
            isDefault = false;
            jsonData = {
              volumeEnabled = true;
            };
          }
        ] ++ lib.optional config.monitoring.tempoServer.enable {
          name = "Tempo";
          type = "tempo";
          url = "http://localhost:${toString config.monitoring.tempoServer.port}";
          access = "proxy";
          isDefault = false;
        };
      };
    };

    # Provide the env-var provider values at runtime. Move these to a local
    # secret file/agenix if you need them out of the Nix store too.
    systemd.services.grafana.serviceConfig.Environment = [
      "GF_SECURITY_ADMIN_PASSWORD=1234"
      "GF_SECURITY_SECRET_KEY=SW2YcwTIb9zpOOhoPsMm"
    ];
  };
}
