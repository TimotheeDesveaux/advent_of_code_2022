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

    # Perl
    perl
    perl536Packages.PLS

    # Zig
    zig
    zls

    # Ruby
    ruby_3_1
    rubyPackages_3_1.solargraph
  ];
  shellHook = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';
}
