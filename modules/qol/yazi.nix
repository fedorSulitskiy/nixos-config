{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withYazi.enable =
      lib.mkEnableOption "enables yazi terminal file manager on this machine";
  };

  config = lib.mkIf config.withYazi.enable {
    environment.systemPackages = with pkgs; [
      yazi
      zoxide
    ];
  };
}
