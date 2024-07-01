{ pkgs ? import ./nix/nixpkgs.nix {} }:
let
  clash-playground =
    pkgs.haskellPackages.callCabal2nix "clash-playground" ./. { };

in pkgs.haskellPackages.shellFor {
  packages = p: [ clash-playground ];
  nativeBuildInputs = [
    pkgs.haskellPackages.cabal-install
  ];
}
