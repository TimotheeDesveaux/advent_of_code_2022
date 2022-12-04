{ pkgs ? import <nixos> { } }:
pkgs.mkShell
{
  name = "aoc-2022-env";
  nativeBuildInputs = with pkgs; [
    # Ocaml
    ocaml
    ocamlPackages.ocaml-lsp

    # Nim
    nim
    nimlsp

    # D
    dmd
  ];
  shellHook = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';
}
