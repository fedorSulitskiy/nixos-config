{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withGcloud.enable =
      lib.mkEnableOption "enables Google Cloud Platform CLI on this machine";
  };

  config = lib.mkIf config.withGcloud.enable {
    environment.systemPackages = with pkgs; [
      google-cloud-sdk
    ];
  };
}

