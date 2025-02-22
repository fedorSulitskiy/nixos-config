{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # # Set the boot drive
  # boot.loader.grub.device = "/dev/sda";

  # Configure keymap in X11
  services.xserver.xkb.layout = "uk";

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
