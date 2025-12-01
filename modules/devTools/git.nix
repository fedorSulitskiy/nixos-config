{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withGit.enable =
      lib.mkEnableOption "enables various Git-related services on this machine";
  };

  config = lib.mkIf config.withGit.enable {
    environment.systemPackages = with pkgs; [
      gh
      git
      lazygit
    ];
  };
}
