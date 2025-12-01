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
    videoDrivers = ["nvidia"]; # load NVIDIA proprietary driver for X
  };

  # Enable picom compositor (window transparency & shadows)
  services.picom = {
    enable = true; # run piccom compositing manager
    backend = "glx"; # use OpenGL backend for better performance
    fade = true; # fade windows when showing/hiding
  };

  # Configure NVIDIA GPU
  hardware.nvidia = {
    open = false; # use closed-source driver (not nouveau)
    nvidiaSettings = true; # install nvidia-settings GUI tool
    package = config.boot.kernelPackages.nvidiaPackages.stable; # pin stable driver version
    modesetting.enable = true; # better kernel modesetting support
  };

  # Enable generic graphics stack and 32-bit libs (needed for Steam, etc.)
  hardware.graphics = {
    enable = true; # enable Mesa and other graphics support
    enable32Bit = true; # also install 32-bit drivers/libs
  };
}
