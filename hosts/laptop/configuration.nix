{
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system/system.nix
    ]
    ++ (import ../../modules);

  withYazi.enable = true;
  withGo.enable = true;
  withGit.enable = true;
  withFly.enable = true;
  withNode.enable = true;
  withRedis.enable = true;
  withPython.enable = true;
  withPostgres.enable = true;
  withGoMigrate.enable = true;
  withNixSupport.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Enable CUPS and add Samsung + common drivers
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      samsung-unified-linux-driver_1_00_36 # Samsung’s own driver
      gutenprint # PCL/PS fallback
    ];
  };

  # 3. (optional) if you also want to scan
  hardware.sane.enable = true;

  # 4. (optional) open firewall so the CUPS web interface is reachable
  networking.firewall.allowedTCPPorts = [631];

  environment.etc."xdg/autostart/klipper-autostart.desktop".enable = false;

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
  system.stateVersion = "25.11"; # Did you read the comment?
}
