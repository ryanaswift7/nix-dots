{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkDefault;
in
{
  options.userSettings = {
    username = mkOption { 
      type = types.str;
      description = "The username for the home profile";
    };

    homeDirectory = mkOption { 
      type = types.str; 
      default = mkDefault "/home/${config.userSettings.username}";
      description = "The home directory for the user";
    };

    dotfileDirectory = mkOption {
      type = types.str;
      default = mkDefault "${config.userSettings.homeDirectory}/nix-dots/dotfiles";
      description = "The dotfile directory for the user";
    };

    systemStateVersion = mkOption {
      type = types.str;
      default = "25.05";
      description = "The NixOS state version (referencing system-level state)";
    };

    homeStateVersion = mkOption {
      type = types.str;
      default = "25.05";
      description = "The Home Manager state version (referencing user-level state)";
    };

    fullName = mkOption {
      type = types.str;
      description = "The full name of the user (used for git)";
    };

    email = mkOption {
      type = types.str;
      description = "The email address for the user (used for git)";
    };

    hostName = mkOption {
      type = types.str;
      description = "The hostname used for the system";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.userSettings.username != "";
        message = "userSettings.username is not set! Please define it in your host configuration.";
      }
      {
        assertion = config.userSettings.fullName != "";
        message = "userSettings.fullName is not set! This is required for Git and system identification.";
      }
      {
        assertion = config.userSettings.email != "";
        message = "userSettings.email is not set! This is required for Git configuration.";
      }
      {
        assertion = config.userSettings.hostName != "";
        message = "userSettings.hostName is not set! Every machine needs a unique name.";
      }
      {
        assertion = config.userSettings.systemStateVersion != "";
        message = "userSettings.systemStateVersion is missing. This will cause issues with NixOS state management.";
      }
      {
        assertion = config.userSettings.homeStateVersion != "";
        message = "userSettings.homeStateVersion is missing. This will cause issues with Home Manager state management.";
      }
    ];
  };
}
