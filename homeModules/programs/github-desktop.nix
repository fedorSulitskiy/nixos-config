{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withGitHubDesktop.enable =
      lib.mkEnableOption "enables GitHub Desktop on this machine";
  };

  config = lib.mkIf config.withGitHubDesktop.enable {
    home.packages = [pkgs.github-desktop];
  };
}
