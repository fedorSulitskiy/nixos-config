# Loki server: centralized log aggregation.
# Stores logs from Promtail clients and serves queries via HTTP API.
# Typically runs on jobs-node to collect all infrastructure logs.
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.monitoring.lokiServer.enable {
    services.loki = {
      enable = true;

      # Loki configuration in YAML format (converted from Nix expression)
      configuration = {
        # Server configuration for Loki's HTTP and gRPC APIs
        server = {
          http_listen_port = config.monitoring.lokiServer.port;
          http_listen_address = "0.0.0.0";
        };

        # Disable multi-tenant authentication (single-tenant setup)
        # When true, requires X-Scope-OrgID header for tenant isolation (allegedly)
        auth_enabled = false;

        # Common configuration shared across Loki components
        common = {
          # Ring configuration for distributed hash table (memberlist)
          ring = {
            # Address to advertise to other ring members (localhost for single-node)
            instance_addr = "127.0.0.1";
            # Use in-memory store for ring membership (suitable for single-node)
            kvstore.store = "inmemory";
          };
          # Number of replicas for each log stream (1 = no redundancy, suitable for single-node)
          replication_factor = 1;
          # Base directory for all Loki data storage
          path_prefix = "/var/lib/loki";
        };

        # Schema configuration defines how logs are indexed and stored
        schema_config = {
          configs = [
            {
              # Date from which this schema is active
              from = "2024-01-01";
              # Index store type: TSDB (Time Series Database) - efficient for log indexing
              store = "tsdb";
              # Object storage backend for log chunks
              object_store = "filesystem";
              # Schema version (v13 is current)
              schema = "v13";
              # Index table configuration
              index = {
                # Prefix for index table names
                prefix = "index_";
                # How often to create new index tables (24 hour periods)
                period = "24h";
              };
            }
          ];
        };

        # Storage backend configuration for log data
        storage_config = {
          # Local filesystem storage for log chunks (the actual log data)
          filesystem = {
            directory = "/var/lib/loki/chunks";
          };
        };

        # Compactor configuration for log retention and cleanup
        compactor = {
          working_directory = "/var/lib/loki/compactor";
        };

        # Limits and retention configuration
        limits_config = {
          retention_period = "30d";
          volume_enabled = true;
        };
      };
    };
  };
}
