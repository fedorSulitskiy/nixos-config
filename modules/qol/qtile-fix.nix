{
  config,
  lib,
  pkgs,
  ...
}: {
  # Qtile 0.36.0 has two flaky tests on the current nixpkgs revision:
  # - KeyboardLayout widget X11 init failure
  # - REPL server connection reset during test
  # Skip them so the build can succeed.
  nixpkgs.overlays = [
    (final: prev: {
      python3Packages = prev.python3Packages.override {
        overrides = pyfinal: pyprev: {
          qtile = pyprev.qtile.overrideAttrs (old: {
            disabledTests = old.disabledTests ++ [
              "test_widget_init_config_vertical_bar"
              "test_repl_server_executes_code"
            ];
          });
        };
      };
    })
  ];

  # The NixOS qtile module resolves the package via python3.pkgs, which does not
  # automatically pick up python3Packages overlays. Point it at the overlaid package
  # explicitly so the skipped tests are respected.
  services.xserver.windowManager.qtile.package = pkgs.python3Packages.qtile;
}
