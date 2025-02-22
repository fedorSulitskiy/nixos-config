{ config, lib, pkgs, ... }:

{
  # Import my neovim config
  systemd.services.clone-neovim-config = {
    description = "Clone NeoVim-Setup repository and rename it to nvim";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    path = with pkgs; [ git ];
    # If no /root/.config directory exists -> create it
    # If my neovim setup is not there -> clone it
    script = ''
      if [ ! -d "/root/.config" ]; then
        echo "Creating /root/.config directory..."
        mkdir -p /root/.config
      fi

      if [ ! -d "/root/.config/nvim" ]; then
        echo "Cloning NeoVim-Setup repository..."
        git clone https://github.com/fedorSulitskiy/NeoVim-Setup.git /root/.config/NeoVim-Setup
        mv /root/.config/NeoVim-Setup /root/.config/nvim
        echo "NeoVim-Setup cloned and renamed to nvim."
      else
        echo "nvim directory already exists. Skipping clone."
      fi
    '';
  };

  # Set neovim as default editor
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  environment.variables = {
    EDITOR = "nvim";
  };
}
