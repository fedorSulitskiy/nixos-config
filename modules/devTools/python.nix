{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withPython.enable =
      lib.mkEnableOption "enables various python versions on this machine";
  };

  config = lib.mkIf config.withPython.enable {
    environment.systemPackages = with pkgs; [
      uv
      poetry
      python312
      python312Packages.pip
      python312Packages.pynvim
      python313
      python313Packages.jedi-language-server
      python314
    ];
  };
}
