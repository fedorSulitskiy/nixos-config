{inputs, ...}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system/system.nix
    ]
    ++ (import ../../modules);

  withYazi.enable = true;
  withGo.enable = true;
  withJq.enable = true;
  withGit.enable = true;
  withFly.enable = true;
  withNode.enable = true;
  withRedis.enable = true;
  withPython.enable = true;
  withOllama.enable = true;
  withRabbitMQ.enable = true;
  withPostgres17.enable = true;
  withGoMigrate.enable = true;
  withNixSupport.enable = true;

  # Monitoring suite
  monitoring = {
    grafana = {
      enable = true;
    };
    prometheus.enable = true;
    lokiServer.enable = true;
    lokiClient = {
      enable = true;
      jobName = "local-logs";
      serverAddress = "localhost";
      serverPort = 3100;
    };
    tempoServer = {
      enable = true;
      port = 3200;
    };
    httpApi = [
      {
        name = "cron-api";
        port = 8090;
      }
      {
        name = "worker-api";
        port = 8100;
      }
      {
        name = "generic-api";
        port = 8080;
      }
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/f0796dfd-71d8-4091-9369-305803cac7cd";
    fsType = "ext4";
    options = ["defaults"];
  };

  nix.settings.trusted-users = [
    "root"
    "fedor"
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
