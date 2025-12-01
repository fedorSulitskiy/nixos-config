{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withYaak.enable =
      lib.mkEnableOption "enables yaak on this machine";
  };

  config = lib.mkIf config.withYaak.enable {
    home.packages = with pkgs; [
      yaak
    ];

    home.sessionVariables = {
      WEBKIT_DISABLE_COMPOSITING_MODE = 1;
      WEBKIT_DISABLE_DMABUF_RENDERER = 1;
    };
  };
}
