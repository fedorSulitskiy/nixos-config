{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnumake
    neovim
    lazygit
    git
    wget
    neofetch
    hyfetch
    cargo
    ripgrep
    nixpkgs-fmt
    gh
    gcc
    go
    gopls
    python312
    python312Packages.jedi-language-server
  ];
}
