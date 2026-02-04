{
  config,
  lib,
  pkgs,
  ...
}: {
  # Setup options
  options.nvim = {
    localSrc = lib.mkOption {
      type = lib.types.path;
      description = "Local path to nvim config (requires --impure)";
    };
    githubSrc = lib.mkOption {
      type = lib.types.path;
      description = "GitHub-fetched nvim config (pure)";
    };
    useLocal = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use local path (true, requires --impure) or GitHub (false, pure)";
    };
  };

  # Configure
  config = let
    nvimSrc =
      if config.nvim.useLocal
      then config.nvim.localSrc
      else config.nvim.githubSrc;
  in {
    home.packages = with pkgs; [
      vim
      neovim

      # All the shit to get it to work
      alejandra
      wget
      fd
      ripgrep
      cargo
      just
      just-lsp
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
      terraform-ls
    ];

    # copy the same nvim config
    xdg.configFile."nvim" = {
      source = pkgs.lib.cleanSource nvimSrc;
      recursive = true;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
