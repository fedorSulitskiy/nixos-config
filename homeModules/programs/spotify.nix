{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withSpotify.enable =
      lib.mkEnableOption "enables Spotify on this machine";
  };

  config = lib.mkIf config.withSpotify.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
