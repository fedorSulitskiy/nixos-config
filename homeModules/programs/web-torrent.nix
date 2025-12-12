{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withWebTorrent.enable =
      lib.mkEnableOption "enables WebTorrent on this machine";
  };

  config = lib.mkIf config.withWebTorrent.enable {
    home.packages = with pkgs; [
        webtorrent_desktop
    ];
  };
}
