{ config, lib, ... }:

{
  options.systemFeatures.time.enable = lib.mkEnableOption "Time settings";

  config = lib.mkIf config.systemFeatures.time.enable {
    time.timeZone = "America/Los_Angeles";
    time.hardwareClockInLocalTime = true; # Fixes dual boot clock sync issues
  };
}
