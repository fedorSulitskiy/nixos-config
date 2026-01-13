{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPostgres17.enable =
      lib.mkEnableOption "enables PostgreSQL 17.11 on this machine";
  };

  config = lib.mkIf config.withPostgres17.enable {
    environment.systemPackages = with pkgs; [
      postgresql_17
      postgresql17Packages.pgvector
      postgresql17Packages.pgsql-http
      postgresql17Packages.postgis
      postgresql17Packages.pgsodium
      postgresql17Packages.pg_graphql
      postgresql17Packages.pg_net
    ];

    services.postgresql = {
      enable = true;
      ensureDatabases = ["comcap_engine"];
      authentication = pkgs.lib.mkOverride 10 ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             ::1/128                 trust
        host    all             all             127.0.0.1/32            trust
      '';
      settings = {
        listen_addresses = "localhost";
      };
      extensions = with pkgs.postgresql_17.pkgs; [pgvector pgsql-http postgis pgsodium pg_graphql pg_net];
      package = pkgs.postgresql_17;
    };
  };
}
