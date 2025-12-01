{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withHttpie.enable =
      lib.mkEnableOption "enables Httpie on this machine";
  };

  config = lib.mkIf config.withHttpie.enable {
    home.packages = with pkgs; [
      httpie-desktop
    ];
  };
}
