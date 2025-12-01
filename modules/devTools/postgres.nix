{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPostgres.enable =
      lib.mkEnableOption "enables PostgreSQL on this machine";
  };

  config = lib.mkIf config.withPostgres.enable {
    environment.systemPackages = with pkgs; [
      postgresql_16
      postgresql16Packages.pgvector
    ];

    services.postgresql = {
      enable = true;
      ensureDatabases = ["comcap_engine"];
      authentication = pkgs.lib.mkOverride 10 ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
      '';
      extensions = with pkgs.postgresql_16.pkgs; [pgvector];
      package = pkgs.postgresql_16;
    };
  };
}
