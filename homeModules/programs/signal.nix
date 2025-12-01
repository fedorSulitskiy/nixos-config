{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withSignal.enable =
      lib.mkEnableOption "enables Signal on this machine";
  };

  config = lib.mkIf config.withSignal.enable {
    home.packages = with pkgs; [
      signal-desktop
    ];
  };
}
