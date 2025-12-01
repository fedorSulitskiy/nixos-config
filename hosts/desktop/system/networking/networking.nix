{
  config,
  lib,
  pkgs,
  ...
}: {
  /*
  * Host identity
  * ===============
  * Set the machine hostname. This becomes part of the prompt, is used by
  * NetworkManager, Avahi, etc., and is helpful for distinguishing systems
  * in multi-host environments.
  */
  networking.hostName = "nixos-btw";

  /*
  * Network
  * =======
  * Use NetworkManager for connection management (wired, Wi-Fi, VPN,
  * mobile). Convenient for desktops/laptops where connections change
  * frequently.
  */
  networking.networkmanager.enable = true;

  /*
  * Firewall
  * ==========
  * Disable reverse-path-filter check (RFC 3704). Helps with asymmetric
  * routing or VPN setups but is less strict on spoofing. Drop this line if
  * you want the default stricter behaviour.
  */
  networking.firewall.checkReversePath = false;
}
