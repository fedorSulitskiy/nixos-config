{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true; # start the X11 display server
    windowManager.qtile.enable = true; # use Qtile as tiling window manager
  };

  # Enable picom compositor (window transparency & shadows)
  services.picom = {
    enable = true; # run piccom compositing manager
    backend = "glx"; # use OpenGL backend for better performance
    fade = true; # fade windows when showing/hiding
  };
}
