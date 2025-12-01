{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withRedis.enable =
      lib.mkEnableOption "enables Redis on this machine";
  };

  config = lib.mkIf config.withRedis.enable {
    environment.systemPackages = with pkgs; [
      redis
    ];
  };
}
