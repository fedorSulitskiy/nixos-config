{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withVoov.enable =
      lib.mkEnableOption "enables Voov on this machine";
  };

  config = lib.mkIf config.withVoov.enable {
    home.packages = with pkgs; [
      wemeet
    ];
  };
}

