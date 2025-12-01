{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tree
    neofetch
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      neofetch
    '';
  };
}
