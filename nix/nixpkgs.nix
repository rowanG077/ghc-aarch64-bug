{ sources ? import ./sources.nix }:

let
  overlay = _: pkgs:

  {

    # Nix tooling
    niv = (import sources.niv {}).niv;
    gitignore = import sources.gitignore { inherit (pkgs) lib; };

    haskell = pkgs.haskell // {
      compiler = pkgs.haskell.compiler // {
        ghc965 = pkgs.haskell.compiler.ghc965.overrideAttrs (old: {
          pname = "${old.pname}-patched";
          patches = (old.patches or []) ++ [ ./aarch64-reloc.patch ];
        });
      };
    };

    # Haskell overrides
    haskellPackages = pkgs.haskell.packages.ghc965.override {
      overrides = self: super: {

        ghc-typelits-natnormalise = self.callCabal2nix "ghc-typelits-natnormalise" sources.ghc-typelits-natnormalise {};

        doctest-parallel =
          self.callCabal2nix "doctest-parallel" sources.doctest-parallel {};
        clash-prelude =
          pkgs.haskell.lib.dontCheck (self.callCabal2nix "clash-prelude" (sources.clash-compiler + "/clash-prelude") {});
        clash-prelude-hedgehog =
          self.callCabal2nix "clash-prelude-hedgehog" (sources.clash-compiler + "/clash-prelude-hedgehog") {};
        clash-lib =
          self.callCabal2nix "clash-lib" (sources.clash-compiler + "/clash-lib") {};
        clash-ghc =
          self.callCabal2nix "clash-ghc" (sources.clash-compiler + "/clash-ghc") {};
        tasty-hedgehog =
          pkgs.haskell.lib.doJailbreak (self.callCabal2nix "tasty-hedgehog" sources.tasty-hedgehog {});
        hedgehog =
          self.callCabal2nix "hedgehog" (sources.haskell-hedgehog + "/hedgehog") {};
      };
    };
  };

in import sources.nixpkgs { overlays = [ overlay ]; }
