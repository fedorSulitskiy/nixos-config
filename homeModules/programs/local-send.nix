{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withLocalSend.enable =
      lib.mkEnableOption "enables LocalSend on this machine";
  };

  config = lib.mkIf config.withLocalSend.enable {
    home.packages = with pkgs; [
      localsend
    ];
  };
}

