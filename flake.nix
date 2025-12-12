{
  description = "Fedor's Systems Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    catppuccin,
  } @ inputs: {
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
              nvimSrc = ./dotfiles/nvim;
            };

            # Root user configuration
            home-manager.users.root = import ./hosts/desktop/home.nix {
              username = "root";
              homeDirectory = "/root";
              nvimSrc = ./dotfiles/nvim;
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

            # Fedor user configuration
            home-manager.users.fedor = import ./hosts/laptop/home.nix {
              username = "fedor";
              homeDirectory = "/home/fedor";
              nvimSrc = ./dotfiles/nvim;
              catppuccin = catppuccin.homeModules.catppuccin;
            };

            # Root user configuration
            home-manager.users.root = import ./hosts/laptop/home.nix {
              username = "root";
              homeDirectory = "/root";
              nvimSrc = ./dotfiles/nvim;
              catppuccin = catppuccin.homeModules.catppuccin;
            };
          }
        ];
      };
    };
  };
}
