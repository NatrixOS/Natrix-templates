{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "hyprnix";
    useDHCP = false; # iwd uses dhcp by default
    
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          AddressRandomization = "once";
          AddressRandomizationRange = "full";
          EnableNetworkConfiguration = true;
          RoamThreshold = -75;
          RoamThreshold5G = -80;
        };
        Network = {
          NameResolvingService = "systemd";
        };
        Scan = {
          DisablePeriodicScan = true;
          MaximumPeriodicScanInterval = 600;
        };
        Settings = {
          AlwaysRandomizeAddress = true;
          AutoConnect = true;
          Hidden = true;
        };
      };
    };

    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  };

  services.resolved = {
    enable = true;
    domains = [ "~." ];
    dnssec = "true";
    dnsovertls = "true";
    fallbackDns = [ "8.8.8.8" "8.8.4.4" ];
  };

  systemd.network.links."80-iwd" = lib.mkForce {
    matchConfig.Type = "wlan";
    linkConfig.NamePolicy = "database onboard slot path mac";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
