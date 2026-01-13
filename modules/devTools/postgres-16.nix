{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPostgres16.enable =
      lib.mkEnableOption "enables PostgreSQL 16.11 on this machine";
  };

  config = lib.mkIf config.withPostgres16.enable {
    environment.systemPackages = with pkgs; [
      postgresql_16
      postgresql16Packages.pgvector
      postgresql16Packages.pgsql-http
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
      extensions = with pkgs.postgresql_16.pkgs; [pgvector pgsql-http];
      package = pkgs.postgresql_16;
    };
  };
}
