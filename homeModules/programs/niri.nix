{
  config,
  lib,
  pkgs,
  ...
}: {
  options.withNiri.enable =
    lib.mkEnableOption "manages niri config.kdl from dotfiles";

  config = lib.mkIf config.withNiri.enable {
    # Niri auto-starts xwayland-satellite when an X11 client (e.g. Steam)
    # launches, but only if the binary is in the user's PATH.
    home.packages = [pkgs.xwayland-satellite];

    xdg.configFile."niri" = {
      source = ../../dotfiles/niri;
      recursive = true;
    };
  };
}
