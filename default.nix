with import ./nix/nixpkgs.nix {};

stdenv.mkDerivation{
    name = "clash-playground";
    src = ./. ;
}
