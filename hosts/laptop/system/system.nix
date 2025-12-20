{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./visuals/desktop.nix
    ./visuals/fonts.nix
    ./visuals/kvantum.nix
    ./visuals/graphics.nix

    ./networking/networking.nix
    ./networking/bluetooth.nix

    ./locale/language.nix
    ./locale/timezone.nix

    ./sound/sound.nix

    ./users/fedor.nix

    ./basics/boot.nix
    ./basics/clipboard.nix
    ./basics/xdg.nix
  ];

  soundOn.enable = true;
  plasma.enable = true;
}
