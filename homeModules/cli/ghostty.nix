{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.ghostty];

  programs.ghostty.settings = {
    font-family = "JetBrainsMono NF Regular";
    font-family-bold = "JetBrainsMono NF Bold";
    font-family-italic = "JetBrainsMono NF Italic";
    font-family-bold-italic = "JetBrainsMono NF Bold Italic";
  };
}
