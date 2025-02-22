# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Set the boot drive
  boot.loader.grub.device = "dev/sda";

  # Configure keymap in X11
  services.xserver.xkb.layout = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fedor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
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
    gcc
    go
    gopls
    python312
    python312Packages.jedi-language-server
  ];

  # Docker Setup
  virtualisation.docker.enable = true;

  # Postgres Setup
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    # Ensure your database exists
    ensureDatabases = [ "bottom_line_db" ];
    # Allow connections from Docker network
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all            all                                     trust
      host    all            all             127.0.0.1/32           trust
      host    all            all             172.17.0.0/16          md5    # Docker subnet
      host    all            all             192.168.1.96/32        md5    # Your server IP
    '';
    # Initial setup script
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE USER postgres WITH SUPERUSER PASSWORD '1234';
      GRANT ALL PRIVILEGES ON DATABASE bottom_line_db TO postgres;
    '';
  };

  # Neovim Setup
  systemd.services.clone-neovim-config = {
    description = "Clone NeoVim-Setup repository and rename it to nvim";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    path = with pkgs; [ git ];
    script = ''
      # Create the /root/.config directory if it doesn't exist
      if [ ! -d "/root/.config" ]; then
        echo "Creating /root/.config directory..."
        mkdir -p /root/.config
      fi

      # Clone the repository if it doesn't already exist
      if [ ! -d "/root/.config/nvim" ]; then
        echo "Cloning NeoVim-Setup repository..."
        git clone https://github.com/fedorSulitskiy/NeoVim-Setup.git /root/.config/NeoVim-Setup
        # Rename the directory
        mv /root/.config/NeoVim-Setup /root/.config/nvim
        echo "NeoVim-Setup cloned and renamed to nvim."
      else
        echo "nvim directory already exists. Skipping clone."
      fi
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = { PermitRootLogin = "yes"; };
  };
  # Basic SSH intrusion protection
  services.fail2ban.enable = true;

  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Prevent the laptop from sleeping
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  #############################################################################################################################

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
