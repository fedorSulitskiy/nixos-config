{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withDiscord.enable =
      lib.mkEnableOption "enables Discord on this machine";
  };

  config = lib.mkIf config.withDiscord.enable {
    home.packages = [pkgs.discord];
  };
}
