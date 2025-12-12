{
  username,
  homeDirectory,
  nvimSrc,
}: {lib, ...}: {
  _module.args = {inherit nvimSrc;};

  imports = import ../../homeModules;

  withZoom.enable = true;
  withYaak.enable = true;
  withHttpie.enable = true;
  withProton.enable = true;
  withSignal.enable = true;
  withVscode.enable = true;
  withDiscord.enable = true;
  withSpotify.enable = true;
  withObsidian.enable = true;
  withWebTorrent.enable = true;
  withDragonPlayer.enable = true;
  withGitHubDesktop.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";
}
