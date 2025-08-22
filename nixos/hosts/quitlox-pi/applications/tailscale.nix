{
  # https://tailscale.com/download/linux/nixos

  services.tailscale.enable = true;

  networking.nameservers = [
    "100.100.100.100"
    "8.8.8.8"
    "1.1.1.1"
  ];
  networking.search = [ "llama-mark.ts.net" ];
}
