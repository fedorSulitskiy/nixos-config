{pkgs, ...}: {
  home.packages = with pkgs; [
    tree
    fastfetch
    fzf
    lsd
    bat
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      fastfetch -c examples/27.jsonc
    '';
    shellAliases = {
      ll = "ls -Alh";
      ls = "lsd --group-dirs first";
      cat = "bat";
    };
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
}
