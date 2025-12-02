{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.fedor = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };
}
