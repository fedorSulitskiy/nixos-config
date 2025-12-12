{
  username,
  homeDirectory,
  nvimSrc,
  catppuccin,
}: {...}: {
  _module.args = {inherit nvimSrc;};

  imports = import ../../homeModules ++ [catppuccin];

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

  catppuccin.fcitx5 = {
    enable = true;
    apply = true;
    enableRounded = true;
    flavor = "mocha";
    accent = "mauve";
  };

  catppuccin.cursors = {
    enable = true;
    flavor = "mocha";
    accent = "dark";
  };
}
