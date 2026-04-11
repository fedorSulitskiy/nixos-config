{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withJq.enable =
      lib.mkEnableOption "enables jq on this machine";
  };

  config = lib.mkIf config.withJq.enable {
    environment.systemPackages = with pkgs; [
      jq
    ];
  };
}

