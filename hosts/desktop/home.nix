{
  username,
  homeDirectory,
  nvimLocalSrc,
  nvimGithubSrc,
}: {...}: {
  imports = import ../../homeModules;

  # Nvim config: set useLocal = true for local dev (requires --impure)
  #              set useLocal = false for pure GitHub builds
  nvim.localSrc = nvimLocalSrc;
  nvim.githubSrc = nvimGithubSrc;
  nvim.useLocal = true;

  withOBS.enable = true;
  withYaak.enable = true;
  withEnte.enable = true;
  withHttpie.enable = true;
  withSteam.enable = true;
  withProton.enable = true;
  withSignal.enable = true;
  withVscode.enable = true;
  withDiscord.enable = true;
  withSpotify.enable = true;
  withObsidian.enable = true;
  withGitHubDesktop.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";
}
