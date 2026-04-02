{pkgs, ...}: {
  home.packages = with pkgs; [
    tree
    fastfetch
    fzf
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      fastfetch -c examples/27.jsonc
    '';
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
}
