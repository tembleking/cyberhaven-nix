{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      cyberhaven = pkgs.callPackage ./cyberhaven.nix { };
    in
    {
      packages.${system} = rec {
        inherit cyberhaven;
        default = cyberhaven;
      };

      nixosModules.cyberhaven = import ./cyberhaven-module.nix { inherit cyberhaven; };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
