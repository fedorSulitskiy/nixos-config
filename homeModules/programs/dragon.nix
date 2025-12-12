{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withDragonPlayer.enable =
      lib.mkEnableOption "enables Dragon Player on this machine";
  };

  config = lib.mkIf config.withDragonPlayer.enable {
    home.packages = [
      pkgs.kdePackages.dragon
    ];
  };
}
