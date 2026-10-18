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
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    opencode-flake.url = "github:Hy4ri/opencode-flake";
    flyline.url = "github:HalFrgrd/flyline";

    # GitHub source for neovim config (pure builds)
    neovim-config = {
      url = "github:fedorSulitskiy/neovim-config";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    noctalia,
    home-manager,
    zen-browser,
    catppuccin,
    neovim-config,
    opencode-flake,
    flyline,
  } @ inputs: let
    # Nvim config sources - both are always available
    nvimLocalSrc = /home/fedor/nixos-config/dotfiles/nvim;
    nvimGithubSrc = neovim-config;

    # Zen upstream re-uploaded the 1.23.3b tarball; youwen5/zen-browser-flake
    # still pins the old hash. Remove once upstream sources.json is fixed.
    zenHash = "sha256-uyBF0+IWVNQP6EElAJLurf0sH8gx7vtQkiJ3PIvcoUk=";
    mkZen = pkgs: let
      z = zen-browser.packages.${pkgs.stdenv.hostPlatform.system};
    in
      z.default.override {
        zen-browser-unwrapped = z.zen-browser-unwrapped.override {hash = zenHash;};
      };
  in {
    nixosConfigurations = {
      nixos-btw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop/configuration.nix
          ./hosts/desktop/hardware-configuration.nix

          flyline.nixosModules.default
          noctalia.nixosModules.default

          ({pkgs, ...}: {
            environment.systemPackages = [
              (mkZen pkgs)
              opencode-flake.packages.${pkgs.stdenv.hostPlatform.system}.opencode
            ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            # Fedor user configuration
            home-manager.users.fedor = import ./hosts/desktop/home.nix {
              username = "fedor";
              homeDirectory = "/home/fedor";
              inherit nvimLocalSrc nvimGithubSrc inputs;
            };

            # Root user configuration
            home-manager.users.root = import ./hosts/desktop/home.nix {
              username = "root";
              homeDirectory = "/root";
              inherit nvimLocalSrc nvimGithubSrc inputs;
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
          flyline.nixosModules.default

          ({pkgs, ...}: {
            environment.systemPackages = [
              (mkZen pkgs)
              opencode-flake.packages.${pkgs.stdenv.hostPlatform.system}.opencode
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
