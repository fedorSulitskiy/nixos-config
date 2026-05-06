# Centralized monitoring option declarations.
# These options are consumed by per-host configurations to enable
# and configure monitoring components (Prometheus, Loki, exporters).
# Usage in host config example:
#   monitoring.prometheus.enable = true;
#   monitoring.nodeExporter = { enable = true; name = "my-node"; };
{lib, ...}: {
  options.monitoring = {
    # Prometheus time-series database for metrics collection
    prometheus = {
      enable = lib.mkEnableOption "Prometheus monitoring";
      port = lib.mkOption {
        type = lib.types.int;
        default = 9090;
        description = "Prometheus listening port";
      };
    };

    # List of HTTP APIs that expose /metrics endpoints for scraping
    httpApi = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Prometheus job name for this API";
            };
            port = lib.mkOption {
              type = lib.types.int;
              description = "Port the API listens on";
            };
            metricsPath = lib.mkOption {
              type = lib.types.str;
              default = "/metrics";
              description = "HTTP path to scrape metrics from";
            };
            scrapeInterval = lib.mkOption {
              type = lib.types.str;
              default = "10s";
              description = "How often Prometheus scrapes this target";
            };
          };
        }
      );
      default = [];
      description = "Local HTTP API instances to scrape Prometheus metrics from";
    };

    # Remote Prometheus scrape targets (other hosts' exporters)
    remoteTargets = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            jobName = lib.mkOption {
              type = lib.types.str;
              description = "Prometheus job name";
            };
            address = lib.mkOption {
              type = lib.types.str;
              description = "Remote host IP or hostname";
            };
            port = lib.mkOption {
              type = lib.types.int;
              description = "Exporter port on remote host";
            };
          };
        }
      );
      default = [];
      description = "Remote Prometheus scrape targets";
    };

    # Grafana dashboard for metrics visualization
    grafana = {
      enable = lib.mkEnableOption "Grafana dashboard";
      adminPassword = lib.mkOption {
        type = lib.types.str;
        default = "admin";
        description = "Grafana admin password";
      };
    };

    # Loki log aggregation server (receives logs from Alloy clients)
    lokiServer = {
      enable = lib.mkEnableOption "Loki log aggregation server";
      port = lib.mkOption {
        type = lib.types.int;
        default = 3100;
        description = "Loki HTTP server port";
      };
    };

    # Grafana Alloy log shipping agent (sends logs to Loki server)
    lokiClient = {
      enable = lib.mkEnableOption "Alloy log shipping agent";
      serverAddress = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Loki server address to push logs to";
      };
      serverPort = lib.mkOption {
        type = lib.types.int;
        default = 3100;
        description = "Loki server port";
      };
      jobName = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "Job name label for logs from this source";
      };
    };

    # Tempo distributed tracing backend (receives traces from Alloy clients)
    tempoServer = {
      enable = lib.mkEnableOption "Tempo distributed tracing backend";
      port = lib.mkOption {
        type = lib.types.int;
        default = 3200;
        description = "Tempo HTTP server port";
      };
    };
  };
}
