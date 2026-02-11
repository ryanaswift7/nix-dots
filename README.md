# Welcome to my NixOS/Home Manager repo!

This is the repo where I keep my personal system configurations that I use every day. This repo follows a hierarchical dendritic pattern, with separation between system and home modules. Files are created for each feature and (optionally) organized into suites. When creating a new host configuration, all I have to do is collect the hardware configuration, enable the suites and/or features I want on that host, fill out the identity file (see below), and then I'm ready to add the flake output and build it!  


## User Identity File
In the process of trying to configure my Home Manager to be portable to other non-NixOS distros, I found that creating a nix module to store the user settings made it much easier to have a single source of truth referenced by both the system and home configurations. Thus, in addition to each host directory containing the `configuration.nix`, `home.nix`, etc. I have added an `identity.nix`, an example of which is shown below:
```
# hosts/home-desktop/identity.nix
{
  username = "ryan";
  fullName = "Ryan Swift";
  email = "ryanaswift7@gmail.com";
  hostName = "home-desktop";
  systemStateVersion = "25.05";
  homeStateVersion = "25.05";
  isNixOS = true;
}
```
After using my custom mkUserSettings function, the output of `identity.nix` (which I refer to as userSettings) is used across my configurations.


## Adding a new host
Effectively, all that is necessary to add a new host to the flake is to create a new directory for the host's configuration files, store the hardware, system, home, and identity configurations there, and add the new flake output to `flake.nix`. The easiest way to do this would be copying everything over from an existing configuration and modifying it as needed. Note that the `hardware-configuration.nix` does need to be the one generated for your hardware, if trying to set up a new NixOS system.


## More to come...
I'm in the middle of getting 2 papers ready to submit so I don't have a ton of time at the moment. In the (hopefully near) future, I'll update this with much more thorough documentation and do some more rigorous testing for Home Manager compatibility with non-NixOS distros. Check back soon!
