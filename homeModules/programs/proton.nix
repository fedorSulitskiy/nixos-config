{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withProton.enable =
      lib.mkEnableOption "enables various Proton services on this machine";
  };

  config = lib.mkIf config.withProton.enable {
    home.packages = with pkgs; [
      proton-pass
      protonvpn-gui
      protonmail-desktop
    ];
  };
}
