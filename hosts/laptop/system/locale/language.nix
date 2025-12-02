{
  config,
  lib,
  pkgs,
  ...
}: {
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  environment.systemPackages = with pkgs; [
    qt6Packages.fcitx5-configtool
  ];

  # Chinese Setup:
  # Enable Fcitx5 as the system input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    # Add the Rime engine and its data
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-nord
      fcitx5-rime
      rime-data # Essential: provides the dictionary files
    ];
  };

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
