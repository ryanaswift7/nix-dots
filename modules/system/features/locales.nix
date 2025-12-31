{ config, lib, ... }:

let
  cfg = config.systemFeatures.locales;
in
{
  options.systemFeatures.locales = {
    enable = lib.mkEnableOption "System locale and internationalization settings";
  };

  config = lib.mkIf cfg.enable {
    # Set the main system language
    i18n.defaultLocale = "en_US.UTF-8";

    # Set regional formatting for numbers, time, and currency
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
