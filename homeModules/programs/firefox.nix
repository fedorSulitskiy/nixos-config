{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withFirefox.enable =
      lib.mkEnableOption "enables Firefox on this machine";
  };

  config = lib.mkIf config.withFirefox.enable {
    home.packages = with pkgs; [
      firefox
      firefoxpwa
    ];

    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts = [pkgs.firefoxpwa];
    };
  };
}
