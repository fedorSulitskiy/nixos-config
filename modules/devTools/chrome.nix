{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withChrome.enable =
      lib.mkEnableOption "enables Google Chrome on this machine";
  };

  config = lib.mkIf config.withChrome.enable {
    environment.systemPackages = with pkgs; [
      google-chrome
    ];
  };
}

