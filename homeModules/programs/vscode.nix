{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withVscode.enable =
      lib.mkEnableOption "enables Vscode on this machine";
  };

  config = lib.mkIf config.withVscode.enable {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
