{
  config,
  lib,
  ...
}: {
  options.withNiri.enable =
    lib.mkEnableOption "manages niri config.kdl from dotfiles";

  config = lib.mkIf config.withNiri.enable {
    xdg.configFile."niri" = {
      source = ../../dotfiles/niri;
      recursive = true;
    };
  };
}
