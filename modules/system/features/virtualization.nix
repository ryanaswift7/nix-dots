{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.virtualization;
in
{
  options.systemFeatures.virtualization = {
    guest.enable = lib.mkEnableOption "Guest services for running inside a VM (QEMU/KVM/Spice)";
    host.enable = lib.mkEnableOption "Host services for running VMs on this system (Libvirtd/Virt-manager)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.guest.enable {
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
      services.spice-autorandr.enable = true; # Automatically resize resolution
    })

    (lib.mkIf cfg.host.enable {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

      users.users.${config.userSettings.username}.extraGroups = [ "libvirtd" "kvm" ];

      networking.firewall.trustedInterfaces = [ "virbr0" ];

    })
  ];
}
