{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    dualMonitors.enable =
      lib.mkEnableOption "enables dual monitor setup";
  };

  config = lib.mkIf config.dualMonitors.enable {
    # Set up monitor positions
    services.xserver.xrandrHeads = [
      {
        output = "HDMI-0"; # LEFT MONITOR
        primary = true;
        monitorConfig = ''
          Option "Position" "0 0"
        '';
      }
      {
        output = "DP-0"; # RIGHT MONITOR
        monitorConfig = ''
          Option "Position" "1920 0"
        '';
      }
    ];
  };
}
