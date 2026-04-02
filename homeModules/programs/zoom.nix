{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withZoom.enable =
      lib.mkEnableOption "enables zoom calls on this machine";
  };

  config = lib.mkIf config.withZoom.enable {
    home.packages = with pkgs; [
      zoom-us
    ];
  };
}
