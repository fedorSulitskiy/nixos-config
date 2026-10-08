{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    plasma.enable =
      lib.mkEnableOption "enables KDE plasma on this machine";
    niri.enable =
      lib.mkEnableOption "enables niri on this machine";
  };

  config = lib.mkMerge [
    (lib.mkIf config.plasma.enable {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.enable = true;
    })
    (lib.mkIf config.niri.enable {
      programs.niri.enable = true;
      programs.xwayland.enable = true;

      # Noctalia greeter runs under greetd (replaces SDDM)
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${lib.getExe' pkgs.noctalia-greeter "noctalia-greeter-session"}";
          user = "greeter";
        };
      };

      # Lets Noctalia greeter show user avatars from AccountsService
      services.accounts-daemon.enable = true;
    })
  ];
}
