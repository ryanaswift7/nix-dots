{ config, lib, ... }:

{
  options.systemFeatures.printing.enable = lib.mkEnableOption "CUPS printing support";

  config = lib.mkIf config.systemFeatures.printing.enable {
    services.printing.enable = true;
  };
}
