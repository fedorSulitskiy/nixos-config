{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.oh-my-posh];

  programs.oh-my-posh = {
    enable = true;
    useTheme = "tokyonight_storm";
  };
}
