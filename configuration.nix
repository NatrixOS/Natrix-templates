# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    copyKernels = true; # don't know if i need it or not
    efiSupport = true;
    devices = [ "nodev" ]; # don't know what it does
    # font = "${pkgs.grub2}/share/grub/unicode.pf2";
    # timeoutStyle = countdown, menu, or hidden;
    fsIdentifier = "uuid"; # try "label" also
    extraEntries = ''
      menuentry "Reboot" {
        reboot
      }
      menuentry "Poweroff" {
        halt
      }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # for obs
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  networking.hostName = "hyprnix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultCharset = "UTF-8";
    defaultLocale = "en_US.UTF-8";
  };
  
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true; # just for sddm to run in x11 as it doesn't use hyprland as it wayland compositor and will need other wayland compositer if used in wayland mode


  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.blueman.enable = true; # bluetooth
  
  # Enable Sound  # look into hardware.alsa
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hanu58 = {
    enable = true;
    isNormalUser = true; 
    description = "#_dedicated";
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    group = "hanu58";
    createHome = true;
    homeMode = "700";
    home = "/home/hanu58";
    uid = 5800; # for fun
    initialHashedPassword = "$y$j9T$/Uns5ADyjCX3qoWwBj4cw.$ChXNRWdjrzkFJ6sjKSLxXefyxF5RPK4YVbRq2MJJat8";
    useDefaultShell = false; # by default but still here for clearence
    shell = pkgs.fish;
    packages = with pkgs; [
      tree 
    ];
  };

  users.groups.hanu58 = {};
  users.mutableUsers = false; # can't create, delete or modify any user or group;
  users.defaultUserShell = pkgs.fish;


  

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nano
    dunst
    playerctl
    wofi
    kdePackages.dolphin 
    brightnessctl
    pavucontrol
    fastfetch
    obsidian
    lsd
    zoxide
    sublime
    grc
    bat
    fzf
    git
    kitty
    spotify
    lshw # list harware
    desktop-file-utils # to get update-desktop-database and list app in xdg-open chooser
    discord 
    tealdeer
    hashcat
    vscodium
    nodejs_24
    foundry
    python314
    btop
    obs-studio
    tor-browser
  ];


  # Flatpak
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      #update-desktop-database /var/lib/flatpak/exports/share/applications/ # to update mime info and xdg-open app list
    '';
  };

  # Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    #extraPackages = with pkgs; [ neovim-qt xclip ];
  };


  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # default is true
    # withUWSM = true; # look into this
  };

  # programs.uwsm.enable = true;

  # iio hyprland # have to check this out
  #programs.iio-hyprland = {
  #  enable = true;
  #};

  # also check this out
  # services.hypridle.enable

  # Greet Display Manger # setup this
  services.displayManager.sddm = {
    enable = true;
    # theme = "";
    autoNumlock = true;
  };

  # Fish
  programs.fish = {
    enable = true;
    shellAliases = {
      # directory listing
      "ls" = "lsd --color=auto --group-directories-first";
      "la" = "lsd -A --group-directories-first";
      "ll" = "lsd -alFh --group-directories-first";
      "lr" = "lsd -lRh --group-directories-first";
      "lf" = "lsd -l | grep -E -v '^d'";
      "ld" = "lsd -l | grep -E '^d' --color=never";
      # bat
      "cat" = "bat"; # coloured cat
      "cata" = "bat --show-all"; # shows all
      "catp" = "bat -p"; # no numbers
      "catpp" = "bat -pp"; # no numbers and no pager
      "c" = "bat -l rust"; # for coloured output piping
      # alias suwayomi
      "start-suwayomi" = "docker run -it --rm -p 4567:4567 -v /home/hanu58/Tachidesk:/home/suwayomi/.local/share/Tachidesk --user 5800 --name me ghcr.io/suwayomi/tachidesk:v2.0.1761";
      # alias cd
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    shellInit = ''
      zoxide init fish --cmd cd | source
      set fish_greeting ""
      # sponge (shell history)
      set sponge_successful_exit_codes 0 127 
      set sponge_delay 10
      set sponge_allow_previously_successful false
      # fifc
      set -Ux fifc_editor nvim 
      set -U fifc_keybinding \cx
      set -U fifc_fd_opts --hidden
      set -U fifc_bat_opts --style=numbers
      # path 
      set -U fish_user_paths /home/hanu58/.cargo/bin $fish_user_paths
      set -U fish_user_paths /home/hanu58/.local/bin $fish_user_paths
    '';
  };


  # suwayomi server
  #services.suwayomi-server = {
  #  enable = true;
  #};


  # Zsh
  programs.zsh = {
    enable = true;
    # need to import my config here
  };
 
  # Thunar
  #programs.thunar.enable = true;
  #services.gvfs.enable = true;
  

  # session variables 
  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  powerManagement = {  # have to look into this
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # Harware Settings for Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    # powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  # optimous prime nvidia
  
  hardware.nvidia.prime = { # look into this
    # sync.enable = true;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    #intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:6:0:0"; #For AMD GPU
  };

  # Enable xdg portals for better integration with applications
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-hyprland ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Locate 
  services.locate.enable = true;

  # makes boot faster
  # systemd.network.wait-online.enable = false; # not needed if using NetworkManager to make networks
  # systemd.services.NetworkManager-wait-online.enable = false; # disable if using ethernet
  # systemd.services.docker.enable = false;
  # systemd.services.lxd.enable = false;
  # systemd.services.vboxnet0.enable = false;
  services.journald.extraConfig = "
    SystemMaxUse=100 
    MaxRetentionSec=1week
  ";

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

