{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withOllama.enable =
      lib.mkEnableOption "enables Ollama on this machine";
  };

  config = lib.mkIf config.withOllama.enable {
    environment.systemPackages = with pkgs; [
      ollama-cuda
    ];

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = ["gemma4:e4b"];
    };
  };
}
