{
  config,
  lib,
  pkgs,
  ...
}: {
  /*
  * Boot
  * ====
  * Enable systemd-boot as the UEFI-capable bootloader and allow the
  * installer (or nixos-rebuild) to write/modify EFI variables in the
  * motherboard's NVRAM. This is necessary for boot entries to be
  * created/deleted automatically on installs/updates.
  */
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
