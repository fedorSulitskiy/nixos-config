{ config, lib, pkgs, ... }:

{
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
}
