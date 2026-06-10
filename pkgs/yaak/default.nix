{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  dconf,
  cairo,
  pango,
  harfbuzz,
  atk,
  gdk-pixbuf,
  libsoup_3,
  libappindicator-gtk3,
  openssl,
  alsa-lib,
  libdrm,
  mesa,
  nss,
  nspr,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  libxkbcommon,
  systemd,
  libglvnd,
  vulkan-loader,
  libnotify,
  libpulseaudio,
  pipewire,
  speechd,
  libdbusmenu-gtk3,
  adwaita-icon-theme,
  hicolor-icon-theme,
  makeWrapper,
  librsvg,
}: let
  version = "2026.4.0";
  src = fetchurl {
    url = "https://yaak.app/releases/v${version}/deb-x86_64/yaak_${version}_amd64.deb";
    sha256 = "sha256-lrdG12/d1j5o/mo04A+5SD70hcxvaoyJResWuZ4Afzk=";
  };

  buildInputs = [
    webkitgtk_4_1
    gtk3
    glib
    glib-networking
    gsettings-desktop-schemas
    dconf
    cairo
    pango
    harfbuzz
    atk
    gdk-pixbuf
    libsoup_3
    libappindicator-gtk3
    openssl
    alsa-lib
    libdrm
    mesa
    nss
    nspr
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libxkbcommon
    systemd
    libglvnd
    vulkan-loader
    libnotify
    libpulseaudio
    pipewire
    speechd
    libdbusmenu-gtk3
    adwaita-icon-theme
    hicolor-icon-theme
    librsvg
  ];
in
  stdenv.mkDerivation {
    pname = "yaak";
    inherit version src;

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
    ];

    inherit buildInputs;

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Extract the .deb package
      dpkg-deb -x $src .

      # Create output directories
      mkdir -p $out/bin
      mkdir -p $out/share
      mkdir -p $out/lib

      # Copy all binaries from usr/bin
      if [ -d usr/bin ]; then
        cp -r usr/bin/* $out/bin/
      fi

      # Create convenience symlink
      if [ -f $out/bin/yaak-app-client ] && [ ! -f $out/bin/yaak ]; then
        ln -s $out/bin/yaak-app-client $out/bin/yaak
      fi

      # Copy desktop entries
      if [ -d usr/share/applications ]; then
        cp -r usr/share/applications $out/share/
      fi

      # Copy icons
      if [ -d usr/share/icons ]; then
        cp -r usr/share/icons $out/share/
      fi

      # Copy any other resources
      if [ -d usr/share/yaak ]; then
        cp -r usr/share/yaak $out/share/
      fi

      # Copy lib directory if it exists
      if [ -d usr/lib ]; then
        cp -r usr/lib/* $out/lib/
      fi

      runHook postInstall
    '';

    postFixup = ''
      # The .desktop file launches yaak-app-client, so we must wrap it directly
      # wrapGAppsHook3 already wraps it, but we need to add our env vars on top
      if [ -f $out/bin/yaak-app-client ]; then
        wrapProgram $out/bin/yaak-app-client \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
          --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/lib" \
          --prefix XDG_DATA_DIRS : "$out/share:$XDG_DATA_DIRS"
      fi

      # Also wrap yaaknode and yaakprotoc if they exist (they may need libs too)
      for binary in yaaknode yaakprotoc; do
        if [ -f "$out/bin/$binary" ]; then
          wrapProgram "$out/bin/$binary" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/lib"
        fi
      done

      # Fix the .desktop file to use 'yaak' instead of 'yaak-app-client'
      # so both terminal and launcher use the same entry point
      if [ -f $out/share/applications/yaak.desktop ]; then
        sed -i 's/Exec=yaak-app-client/Exec=yaak/' $out/share/applications/yaak.desktop
      fi
    '';

    meta = with lib; {
      description = "Simple, secure, and private API client alternative to Postman";
      homepage = "https://yaak.app";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      maintainers = [];
    };
  }
