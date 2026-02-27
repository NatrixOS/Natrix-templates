{ config, pkgs, ... }:

{
  # imports = [ ./gpu-passthrough.nix ];

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  # Add user to libvirtd group
  users.users.hanu58.extraGroups = [ "libvirtd" "docker"];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
    docker-compose
  ];

  # enable virt-manager
  programs.virt-manager.enable = true;

  # enable Docker support
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    #storageDriver = "btrfs";
    #daemon.settings = {
    #  runtimes.nvidia = {
    #    path = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
    #    runtimeArgs = [];
    #  };
    #};
  };

  # enable LXC support
  # virtualisation.lxd.enable = true;
  # virtualisation.lxc.lxcfs.enable = true;

  # enable VirtualBox
  # virtualisation.virtualbox.host.enable = true;

  # enable VirtualBox ExtensionPack
  #virtualisation.virtualbox.host.enableExtensionPack = true;

  # enable QEMU
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        # ovmf.enable = true;
        # ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  # services.spice-vdagentd.enable = true; # for clipboard sharing

  # gpu to container

  hardware.nvidia-container-toolkit = {
    enable = true;
  };
 
  # vgpu split form flake.nix
  #hardware.nvidia.vgpu = {
  #  patcher.enable = true;
  #};
}
