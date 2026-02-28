{
  description = "Fedor's Systems Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";

    # GitHub source for neovim config (pure builds)
    neovim-config = {
      url = "github:fedorSulitskiy/neovim-config";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    catppuccin,
    neovim-config,
  } @ inputs: let
    # Nvim config sources - both are always available
    nvimLocalSrc = /home/fedor/nixos-config/dotfiles/nvim;
    nvimGithubSrc = neovim-config;
  in {
    nixosConfigurations = {
      nixos-btw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop/configuration.nix
          ./hosts/desktop/hardware-configuration.nix

          ({pkgs, ...}: {
            environment.systemPackages = [
              zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Fedor user configuration
            home-manager.users.fedor = import ./hosts/desktop/home.nix {
              username = "fedor";
              homeDirectory = "/home/fedor";
              inherit nvimLocalSrc nvimGithubSrc;
            };

            # Root user configuration
            home-manager.users.root = import ./hosts/desktop/home.nix {
              username = "root";
              homeDirectory = "/root";
              inherit nvimLocalSrc nvimGithubSrc;
            };
          }
        ];
      };
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/configuration.nix
          ./hosts/laptop/hardware-configuration.nix

          catppuccin.nixosModules.catppuccin

          ({pkgs, ...}: {
            environment.systemPackages = [
              zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # Fedor user configuration
            home-manager.users.fedor = import ./hosts/laptop/home.nix {
              username = "fedor";
              homeDirectory = "/home/fedor";
              inherit nvimLocalSrc nvimGithubSrc;
              catppuccin = catppuccin.homeModules.catppuccin;
            };

            # Root user configuration
            home-manager.users.root = import ./hosts/laptop/home.nix {
              username = "root";
              homeDirectory = "/root";
              inherit nvimLocalSrc nvimGithubSrc;
              catppuccin = catppuccin.homeModules.catppuccin;
            };
          }
        ];
      };
    };
  };
}
