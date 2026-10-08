{
  inputs,
  username,
  homeDirectory,
  nvimLocalSrc,
  nvimGithubSrc,
}: {...}: {
  imports =
    [
      inputs.noctalia.homeModules.default
    ]
    ++ import ../../homeModules;

  # Nvim config: set useLocal = true for local dev (requires --impure)
  #              set useLocal = false for pure GitHub builds
  nvim.localSrc = nvimLocalSrc;
  nvim.githubSrc = nvimGithubSrc;
  nvim.useLocal = true;

  withYaak.enable = true;
  withNiri.enable = true;
  withProton.enable = true;
  withSignal.enable = true;
  withVscode.enable = true;
  withDiscord.enable = true;
  withSpotify.enable = true;
  withObsidian.enable = true;

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/mnt/ssd/Pictures/snow-mountains-3840x2160-25876.jpg";
      };
    };
  };

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";
}
