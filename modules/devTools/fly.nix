{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withFly.enable =
      lib.mkEnableOption "enables fly.io cli on this machine";
  };

  config = lib.mkIf config.withFly.enable {
    environment.systemPackages = with pkgs; [
      flyctl
    ];
  };
}
