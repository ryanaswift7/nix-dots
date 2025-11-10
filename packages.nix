# /etc/nixos/packages.nix

# This is a function that takes an attribute set, and we just
# pull `pkgs` out of it.
{ pkgs, ... }:

{
  # List of packages for the system
  system = with pkgs; [
    git
    vim
    wget
    curl
    tmux
    google-chrome
    kitty
    spice-vdagent
    spice-autorandr
    gh
    btop
    htop

    # From unstable
    # unstable.vscode.fhs
  ];

  # List of packages for the user
  ryan = with pkgs; [
    brave
    vlc
    celluloid
    uv
    wezterm
    networkmanager-openconnect
    unstable.vscode.fhs
    niri
    openconnect-sso
    nerd-fonts.martian-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
    nerd-fonts.space-mono
    nerd-fonts.symbols-only
    cliphist
  ];
}
