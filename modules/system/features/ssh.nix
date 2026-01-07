{ config, lib, ... }:

let
  cfg = config.systemFeatures.ssh;
in
{
  options.systemFeatures.ssh = {
    enable = lib.mkEnableOption "OpenSSH service and firewall configuration";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        # Disable password login (Requires SSH Keys)
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        
        PermitRootLogin = "no";
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
