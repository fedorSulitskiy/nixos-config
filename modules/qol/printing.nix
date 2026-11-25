{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPrinting.enable =
      lib.mkEnableOption "enables CUPS printing with Canon Pixma TS705a support";
  };

  config = lib.mkIf config.withPrinting.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cnijfilter2 # Canon TS700 series PPD (TS705a)
        cups-filters
        cups-browsed
        gutenprint
      ];
    };

    networking.firewall.allowedTCPPorts = [631];

    environment.systemPackages = with pkgs; [
      system-config-printer
    ];
  };
}
