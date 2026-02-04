{ config, lib, pkgs, ... }:

{
  options.systemFeatures.niri.enable = lib.mkEnableOption "Niri Window Manager";

  config = lib.mkIf config.systemFeatures.niri.enable {
    programs.niri = {
      enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      # config.common.default = "gnome";
      config.niri.default = [ "gnome" "gtk" ];
    };

    # services.dbus.packages = with pkgs; [ niri nautilus ];
    # services.displayManager.sessionPackages = [ pkgs.niri ];
    # systemd.user.services.niri.wants = [ "dms.service" ];
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
