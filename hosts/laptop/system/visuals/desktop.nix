{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    plasma.enable =
      lib.mkEnableOption "enables KDE plasma on this machine";
  };

  config = lib.mkIf config.plasma.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
  };
}
