{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tree
    fastfetch
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      fastfetch -c examples/27.jsonc
    '';
  };
}
