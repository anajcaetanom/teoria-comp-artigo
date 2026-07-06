# shell.nix
#
# Uso:
#   nix-shell
#   runghc -isrc app/Main.hs


{ pkgs ? import (fetchTarball {
    # nixpkgs-24.05 — https://github.com/NixOS/nixpkgs/commits/nixos-24.05
    url = "https://github.com/NixOS/nixpkgs/archive/24.05.tar.gz";
  }) {}
}:

let
  ghcWithPackages = pkgs.haskellPackages.ghcWithPackages (hp: with hp; [
    containers
    hspec
  ]);
in
pkgs.mkShell {
  buildInputs = [
    ghcWithPackages
    pkgs.cabal-install
    pkgs.haskellPackages.haskell-language-server
    pkgs.haskellPackages.hlint
  ];

  shellHook = ''
    echo "Ambiente Haskell pronto — GHC $(ghc --numeric-version)"
    echo "Rode 'runghc -isrc app/Main.hs' para executar a demo,"
  '';
}