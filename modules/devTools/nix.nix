{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withNixSupport.enable =
      lib.mkEnableOption "enables Nix supporting software on this machine";
  };

  config = lib.mkIf config.withNixSupport.enable {
    environment.systemPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };
}
