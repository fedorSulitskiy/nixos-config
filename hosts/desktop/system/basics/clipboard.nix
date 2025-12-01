{
  config,
  lib,
  pkgs,
  ...
}: {
  # For the benefit of neovim I needed a dedicated clipboard
  # so it could copy and paste from terminal
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
