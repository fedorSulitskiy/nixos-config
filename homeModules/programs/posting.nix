{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPosting.enable =
      lib.mkEnableOption "enables posting TUI on this machine";
  };

  config = lib.mkIf config.withPosting.enable {
    home.packages = with pkgs; [
      posting
    ];
  };
}
