{pkgs, ...}: {
  # WireGuard VPN client for secure access to InBetween databases-node.
  # Routes only the 10.0.2.0/24 subnet through the tunnel (split-tunnel).
  #
  # My Private Key:
  # cOJYBkPAnmYowICT0RJEnL2EeqF1JGjfd4kkY69IVnc=
  #
  # My Public Key:
  # bc2/90Gy2ELPlckriZRnBERw56X9J9fykyK0BorqMD4=
  #
  # I saved the private key in /etc/wireguard/private.key
  networking.wireguard.interfaces.wg0 = {
    ips = ["10.0.2.2/24"];
    privateKeyFile = "/etc/wireguard/private.key";

    peers = [
      {
        # databases-node server public key
        publicKey = "8dRogkl0tyYxHeN7tG0xPtCKPJpNQdXNTvUSzYmzQjY=";
        endpoint = "91.99.75.162:51820";
        allowedIPs = ["10.0.2.1/32"];
        persistentKeepalive = 25;
      }
    ];
  };

  environment.systemPackages = [pkgs.wireguard-tools];
}
