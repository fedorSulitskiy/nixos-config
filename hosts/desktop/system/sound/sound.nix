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
    * Convenience GUI tools
    * =====================
    * - pavucontrol: classic GTK mixer (works with PipeWire-pulse)
    * - alsa-utils: various audio utilities
    */
    environment.systemPackages = with pkgs; [
      pavucontrol
      alsa-utils
    ];

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
    * Replaces both PulseAudio and Jack; provides audio/routing/video
    * for flatpaks, wayland, and normal apps
    */
    services.pipewire = {
      enable = true; # start pipewire user daemons
      alsa.enable = true; # pipewire-alsa plugin → apps using alsa
      alsa.support32Bit = true; # 32-bit alsa libs for wine/steam
      pulse.enable = true; # pipewire-pulse → apps using pulseaudio
      jack.enable = true; # pipewire-jack → jack clients
    };

    /*
    * WirePlumber session/policy manager tweaks
    * ===========================================
    * 1. Never suspend sinks after 5 s of silence (stops "popping" amps)
    * 2. Keep card in consumer "analog-stereo" profile (not "Pro Audio")
    * 3. Force every stream to the on-board line-out by default
    */
    # services.pipewire.wireplumber.extraConfig."99-no-suspend" = ''
    #   session.suspend-timeout-seconds = 0
    # '';
    #
    # services.pipewire.wireplumber.extraConfig."80-analog-profile" = ''
    #   -- keep the card in consumer mode
    #   api.acp.auto-profile = true
    # '';
    #
    # services.pipewire.wireplumber.extraConfig."81-default-sink" = ''
    #   rule = {
    #     matches = { { } },
    #     apply_properties = {
    #       ["node.target"] = "alsa_output.pci-0000_0a_00.6.analog-stereo",
    #     },
    #   }
    #   table.insert(alsa_monitor.rules, rule)
    # '';
  };
}
