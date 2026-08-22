{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPdfTopPm.enable =
      lib.mkEnableOption "enables various PDF related utils on this machine";
  };

  config = lib.mkIf config.withPdfTopPm.enable {
    environment.systemPackages = with pkgs; [
      poppler-utils
    ];
  };
}
