{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withNode.enable =
      lib.mkEnableOption "enables Node on this machine";
  };

  config = lib.mkIf config.withNode.enable {
    environment.systemPackages = with pkgs; [
      nodejs_24
      nodePackages.pnpm
    ];
  };
}
