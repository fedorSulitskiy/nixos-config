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
          ring = {
            kvstore = {
              store = "inmemory";
            };
          };
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

        # Ingester configuration - writes traces to storage
        ingester = {
          lifecycler = {
            address = "127.0.0.1";
            ring = {
              kvstore = {
                store = "inmemory";
              };
              replication_factor = 1;
            };
            final_sleep = "0s";
          };
          trace_idle_period = "10s";
          max_block_bytes = 1048576;
          max_block_duration = "5m";
        };

        # Compactor configuration
        compactor = {
          compaction = {
            block_retention = "168h";
            compacted_block_retention = "1h";
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

          # Traces storage for local-blocks processor
          traces_storage = {
            path = "/var/lib/tempo/generator/traces";
          };

          # local-blocks processor config
          processor = {
            local_blocks = {
              filter_server_spans = false;
            };
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
              processors = ["service-graphs" "span-metrics" "local-blocks"];
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
      "d /var/lib/tempo/generator/traces 0750 tempo tempo -"
    ];
  };
}
