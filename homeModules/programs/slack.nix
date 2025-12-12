{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withSlack.enable =
      lib.mkEnableOption "enables Slack on this machine";
  };

  config = lib.mkIf config.withSlack.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
