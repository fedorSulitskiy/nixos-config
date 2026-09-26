{pkgs, ...}: {
  home.packages = [pkgs.ghostty];

  programs.ghostty = {
    enable = true;

    enableBashIntegration = true;

    settings = {
      theme = "GitHub Dark";
      font-family = "JetBrainsMono NF Regular";
      font-family-bold = "JetBrainsMono NF Bold";
      font-family-italic = "JetBrainsMono NF Italic";
      font-family-bold-italic = "JetBrainsMono NF Bold Italic";
    };
  };
}
