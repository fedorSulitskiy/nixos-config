{
  nvimSrc,
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    vim
    neovim

    # All the shit to get it to work
    alejandra
    wget
    fd
    ripgrep
    cargo
    gnumake
    gcc
    tree-sitter
    openjdk
    ruby
    julia
    unzip
    php
    lua
    stylua
    luarocks
    lua-language-server
    vimPlugins.none-ls-nvim
    gofumpt
    goimports-reviser
  ];

  # copy the same nvim config
  xdg.configFile."nvim" = {
    source = pkgs.lib.cleanSource nvimSrc;
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
