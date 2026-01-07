{ config, lib, pkgs, ... }:

{
  options.systemFeatures.gnome.enable = lib.mkEnableOption "GNOME Desktop Environment";

  config = lib.mkIf config.systemFeatures.gnome.enable {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Keyring & Polkit
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;
    security.polkit.enable = true;

    # Necessary for some GNOME apps
    programs.gnome-disks.enable = true;
    services.udisks2.enable = true;
  };
}
