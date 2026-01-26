{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withEnte.enable =
      lib.mkEnableOption "enables Ente on this machine";
  };

  config = lib.mkIf config.withEnte.enable {
    home.packages = [pkgs.ente-desktop];
  };
}
