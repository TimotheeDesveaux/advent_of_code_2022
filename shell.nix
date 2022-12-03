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
  ];
}
