{
  username,
  homeDirectory,
  nvimLocalSrc,
  nvimGithubSrc,
  catppuccin,
}: {...}: {
  imports = import ../../homeModules ++ [catppuccin];

  # Nvim config: set useLocal = true for local dev (requires --impure)
  #              set useLocal = false for pure GitHub builds
  nvim.localSrc = nvimLocalSrc;
  nvim.githubSrc = nvimGithubSrc;
  nvim.useLocal = true;

  withZoom.enable = true;
  withYaak.enable = true;
  withSlack.enable = true;
  withHttpie.enable = true;
  withProton.enable = true;
  withSignal.enable = true;
  withVscode.enable = true;
  withDiscord.enable = true;
  withSpotify.enable = true;
  withFirefox.enable = true;
  withObsidian.enable = true;
  withWebTorrent.enable = true;
  withDragonPlayer.enable = true;
  withGitHubDesktop.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  catppuccin.cursors = {
    enable = true;
    flavor = "mocha";
    accent = "dark";
  };
}
