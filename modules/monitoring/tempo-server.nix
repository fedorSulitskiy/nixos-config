# Tempo server: distributed tracing backend.
# Stores traces from Alloy OTEL receivers and serves queries via HTTP API.
# Alloy configuration for trace ingestion is handled by alloy-config.nix.
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.monitoring.tempoServer.enable {
    # Tempo service configuration
    services.tempo = {
      enable = true;

      # Tempo configuration in YAML format
      settings = {
        # Server configuration for Tempo's HTTP and gRPC APIs
        server = {
          http_listen_port = config.monitoring.tempoServer.port;
          http_listen_address = "::";
          grpc_listen_port = 9096;
          grpc_listen_address = "0.0.0.0";
        };

        # Distributor configuration - receives traces from Alloy
        # Note: OTLP ports changed to avoid conflict with Alloy's OTLP receiver
        distributor = {
          receivers = {
            otlp = {
              protocols = {
                http = {
                  endpoint = "0.0.0.0:4328";
                };
                grpc = {
                  endpoint = "0.0.0.0:4327";
                };
              };
            };
          };
        };

        # Storage configuration - local filesystem
        storage = {
          trace = {
            backend = "local";
            local = {
              path = "/var/lib/tempo/traces";
            };
            wal = {
              path = "/var/lib/tempo/wal";
            };
          };
        };

        # Live-store: holds recent traces in memory, flushes to local WAL.
        # v3 defaults point at /var/tempo/... which is outside the service's
        # writable paths (ProtectSystem=strict) — must live under /var/lib/tempo.
        live_store = {
          wal = {
            path = "/var/lib/tempo/live-store/traces";
          };
          shutdown_marker_dir = "/var/lib/tempo/live-store/shutdown-marker";
        };

        # Query frontend configuration
        query_frontend = {
          max_outstanding_per_tenant = 100;
        };

        metrics_generator = {
          # Storage for generated metrics (Prometheus agent WAL)
          storage = {
            path = "/var/lib/tempo/generator/wal";
            remote_write = [
              {
                url = "http://localhost:9090/api/v1/write";
                send_exemplars = true;
              }
            ];
          };

          # Ring configuration for single-node setup
          ring = {
            kvstore = {
              store = "inmemory";
            };
          };
        };

        # Enable the generator in the overrides
        overrides = {
          defaults = {
            metrics_generator = {
              processors = ["service-graphs" "span-metrics"];
            };
          };
        };
      };
    };

    # Ensure data directories exist
    systemd.tmpfiles.rules = [
      "d /var/lib/tempo 0750 tempo tempo -"
      "d /var/lib/tempo/traces 0750 tempo tempo -"
      "d /var/lib/tempo/wal 0750 tempo tempo -"
      "d /var/lib/tempo/generator 0750 tempo tempo -"
      "d /var/lib/tempo/generator/wal 0750 tempo tempo -"
      "d /var/lib/tempo/live-store 0750 tempo tempo -"
      "d /var/lib/tempo/live-store/traces 0750 tempo tempo -"
      "d /var/lib/tempo/live-store/shutdown-marker 0750 tempo tempo -"
    ];
  };
}
