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
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      # nativeMessagingHosts = [pkgs.firefoxpwa];
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
  };
}
