{
  description = "Falsisign script derivation";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    falsisign-src = {
      url = gitlab:edouardklein/falsisign;
      flake = false;
    };
    flake-utils.url = github:numtide/flake-utils;
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, falsisign-src, flake-utils, ... }:
    let
      forSystem = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          drv = pkgs.callPackage ./falsisign {
            inherit pkgs falsisign-src;
          };
        in
        {
          apps = {
            falsisign = drv.falsisign;
            signdiv = drv.signdiv;
          };
          apps.default = drv.falsisign;
          defaultPackage = drv.falsisign;
        };
    in
    flake-utils.lib.eachDefaultSystem forSystem;
}
