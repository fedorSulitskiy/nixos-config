{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withOBS.enable =
      lib.mkEnableOption "enables OBS-Studion on this machine";
  };

  config = lib.mkIf config.withOBS.enable {
    home.packages = with pkgs; [
      obs-studio
    ];
  };
}
