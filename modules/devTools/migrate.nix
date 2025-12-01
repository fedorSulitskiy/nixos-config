
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    withGoMigrate.enable =
      lib.mkEnableOption "enables golang-migrate on this machine";
  };

  config = lib.mkIf config.withGoMigrate.enable {
    environment.systemPackages = with pkgs; [
      go-migrate
    ];

    nixpkgs.overlays = [
      (final: prev: {
        go-migrate = prev.go-migrate.overrideAttrs (old: {
          tags = ["postgres"]; # I only use postgres because I'm a chad
        });
      })
    ];
  };
}
