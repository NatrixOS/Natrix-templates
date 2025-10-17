{ config, pkgs, ... }:

{
  boot.kernelParams = [ "amd_iommu=on" "vfio-pci.ids=10de:1f99,10de:10fa" ];
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"

    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

}
