{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withYaak.enable =
      lib.mkEnableOption "enables Yaak API client on this machine";
  };

  config = lib.mkIf config.withYaak.enable {
    home.packages = [
      (pkgs.callPackage ../../pkgs/yaak {})
    ];
  };
}
