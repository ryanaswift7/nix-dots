{ config, lib, userSettings, ... }:

let
  cfg = config.systemFeatures.autologin;
in
{
  options.systemFeatures.autologin = {
    enable = lib.mkEnableOption "Automatic login for the primary user";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.autoLogin = {
      enable = true;
      user = userSettings.username;
    };

    # Workaround for GNOME autologin: 
    # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}
