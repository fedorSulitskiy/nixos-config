{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = { PermitRootLogin = "yes"; };
  };
}
