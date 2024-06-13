# Cyberhaven Flake

This repository contains a Nix flake for installing and running the Cyberhaven on NixOS. This flake uses an existing Debian package, applies necessary patches, and sets up a systemd service to manage it.

## Installation

### Add the flake to your NixOS configuration

Add the flake to your `flake.nix` configuration file in the inputs and the config:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cyberhaven = {
      url = "github:tembleking/cyberhaven-nix";  # <- Add this input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, cyberhaven }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          cyberhaven.nixosModules.cyberhaven   # <- Add this module config
        ];
      };
    };
  };
}
```

### Configure the service

Add the following to your NixOS configuration file (usually `configuration.nix`):

```nix
{
  services.cyberhaven = {
    enable = true;
    installToken = "your-install-code";
  };
}
```

Replace `"your-install-code"` with your actual install code.

### Rebuild your NixOS system:

```bash
sudo nixos-rebuild switch
```

This command will rebuild your system configuration and start the service.

