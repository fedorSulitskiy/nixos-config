{
  config,
  lib,
  pkgs,
  ...
}: {
  /*
  Enable XDG Desktop Portal: a portal service that lets sandboxed apps
  (Flatpak, Snap, Steam-native, etc.) ask the desktop for privileged
  operations such as
    - opening a file chooser
    - taking screenshots
    - screen sharing

  By default no backend is selected, so we add the GTK portal backend
  (xdg-desktop-portal-gtk) to the extraPortals list. This causes portals
  launched by apps to use GTK dialogs and file choosers, making them
  integrate with an X11 or Wayland session based on GTK.
  */

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
