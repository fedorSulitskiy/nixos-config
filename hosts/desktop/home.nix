{
  username,
  homeDirectory,
  nvimSrc,
}: {...}: {
  _module.args = {inherit nvimSrc;};

  imports = import ../../homeModules;

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
