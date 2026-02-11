# Welcome to my NixOS/Home Manager repo!

This is the repo where I keep my personal system configurations that I use every day. This repo follows a hierarchical dendritic pattern, with separation between system and home modules. Files are created for each feature and (optionally) organized into suites. When creating a new host, all I have to do is collect the hardware configuration, enable the suites and/or features I want on that host, fill out the identity file (see below), and then I'm ready to add the flake output and build it!
