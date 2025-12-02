{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    soundOn.enable =
      lib.mkEnableOption "enables sound on this system";
  };

  config = lib.mkIf config.soundOn.enable {
    /*
    * Low-latency audio support
    * =========================
    * Enable Real-Time-Kit (rtkit) so unprivileged processes can obtain
    * real-time scheduling. Needed for PipeWire and Jack to avoid drop-outs
    * on desktops/laptops.
    */
    security.rtkit.enable = true;

    /*
    * PipeWire media server
    * =====================
    * replaces both PulseAudio and Jack; provides audio/routing/video
    * for flatpaks, wayland, and normal apps
    */
    services.pipewire = {
      enable = true; # start pipewire user daemons
      alsa.enable = true; # pipewire-alsa plugin → apps using alsa
      alsa.support32Bit = true; # 32-bit alsa libs for wine/steam
      pulse.enable = true; # pipewire-pulse → apps using pulseaudio
      jack.enable = true; # pipewire-jack → jack clients
    };
  };
}
