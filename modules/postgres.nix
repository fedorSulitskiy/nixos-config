{ config, lib, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureDatabases = [ "bottom_line_db" ];
    authentication = pkgs.lib.mkOverride 10 ''
      local   all            all                                     trust
      host    all            all             127.0.0.1/32           trust
      host    all            all             172.17.0.0/16          md5    # Docker subnet
      host    all            all             192.168.1.96/32        md5    # Your server IP
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE USER postgres WITH SUPERUSER PASSWORD '1234';
      GRANT ALL PRIVILEGES ON DATABASE bottom_line_db TO postgres;
    '';
  };
}
