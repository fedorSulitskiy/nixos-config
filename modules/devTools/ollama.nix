{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withOllama.enable =
      lib.mkEnableOption "enables Ollama on this machine";

    withOllama.cuda = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the CUDA-accelerated Ollama package (requires NVIDIA GPU).";
    };
  };

  config = lib.mkIf config.withOllama.enable {
    environment.systemPackages = with pkgs; [
      (if config.withOllama.cuda then ollama-cuda else ollama)
    ];

    services.ollama = {
      enable = true;
      package = if config.withOllama.cuda then pkgs.ollama-cuda else pkgs.ollama;
      loadModels = ["gemma4:e4b"];
    };
  };
}
