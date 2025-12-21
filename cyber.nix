{ config, pkgs, ... }:

{
  # enable /etc/hosts editing
  environment.etc.hosts.mode = "0644";
  # environment.etc."hosts".enable = false; # won't generate /etc/hosts

  environment.systemPackages = with pkgs; [
    openvpn
    john
    nmap
    metasploit
    exploitdb
    burpsuite
    feroxbuster
    gobuster
    ffuf
    python313Packages.dirsearch
    ghidra
    binwalk
    exiftool
    jdk
    audacity
    awscli2
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.12"
  ];
}
