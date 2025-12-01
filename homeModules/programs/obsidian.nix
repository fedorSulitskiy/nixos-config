{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withObsidian.enable =
      lib.mkEnableOption "enables Obsidian on this machine";
  };

  config = lib.mkIf config.withObsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
