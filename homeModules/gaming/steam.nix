{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withSteam.enable =
      lib.mkEnableOption "enables Steam on this machine";
  };

  config = lib.mkIf config.withSteam.enable {
    home.packages = [pkgs.steam];
  };
}
