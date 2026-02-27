{ config, pkgs, ... }:

{
  # enable /etc/hosts editing
  environment.etc.hosts.mode = "0644";
  # environment.etc."hosts".enable = false; # won't generate /etc/hosts

  environment.systemPackages = with pkgs; [
    openvpn
    inetutils
    john
    nmap
    metasploit
    exploitdb
    burpsuite
    feroxbuster
    gobuster
    ffuf
    wfuzz
    python313Packages.dirsearch
    ghidra
    binwalk
    exiftool
    jdk
    audacity
    awscli2
    wireshark
    kerbrute
    sqlcmd
    sqsh
    python313Packages.impacket
    evil-winrm
    netexec
    #crackmapexec
    bloodhound-ce
    bloodhound-py
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.12"
  ];
}
