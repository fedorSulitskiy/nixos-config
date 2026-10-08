{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Prefer Noto Color Emoji for emoji codepoints in fontconfig fallback
  fonts.fontconfig.defaultFonts.emoji = ["Noto Color Emoji"];
}
