identity:
let
  checkSet = val: msg: if val == "" || val == null then throw msg else val;
  
  username = checkSet identity.username "userSettings.username is not set!";
  
  # Calculate defaults
  homeDirectory = identity.homeDirectory or "/home/${username}";
  dotfileDirectory = identity.dotfileDirectory or "${homeDirectory}/nix-dots/dotfiles";

in
{
  inherit username homeDirectory dotfileDirectory;
  
  # Inherit and validate other required fields
  fullName = checkSet identity.fullName "userSettings.fullName is not set!";
  email = checkSet identity.email "userSettings.email is not set!";
  hostName = checkSet identity.hostName "userSettings.hostName is not set!";
  systemStateVersion = checkSet identity.systemStateVersion "userSettings.systemStateVersion is not set!";
  homeStateVersion = checkSet identity.homeStateVersion "userSettings.homeStateVersion is not set!";
  isNixOS = checkSet identity.isNixOS "userSettings.isNixOS is not set!";
  wrapGL = pkgs: pkg: program: 
    if identity.isNixOS then 
      "${pkg}/bin/${program}"
    else 
      # Wrap in a login shell to ensure Nix profile is sourced
      "${pkgs.bash}/bin/bash -l -c '${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkg}/bin/${program}'";
}
