{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withGo.enable =
      lib.mkEnableOption "enables Golang on this machine";
  };

  config = lib.mkIf config.withGo.enable {
    environment.systemPackages = with pkgs; [
      go
      richgo
      gopls
      gotools
    ];
  };
}
