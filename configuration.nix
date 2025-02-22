{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/base.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/docker.nix
    ./modules/postgres.nix
    ./modules/neovim.nix
    ./modules/ssh.nix
    ./modules/firewall.nix
    ./services/fail2ban.nix
    ./services/logind.nix
  ];

  system.stateVersion = "24.11";
}
