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

  config = lib.mkIf config.withYaak.enable {
    home.packages = with pkgs; [
      zoom-us
    ];
  };
}
