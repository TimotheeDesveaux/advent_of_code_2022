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

    # Ada
    gnat

    # Scala
    scala
    metals

    # Java
    jdk

    # Kotlin
    kotlin
    kotlin-language-server

    # Swift
    swift

    # JS
    nodejs
    nodePackages_latest.typescript
    nodePackages_latest.typescript-language-server

    # Common Lisp
    sbcl
  ];
  shellHook = ''
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="$HOME/Documents/perso/advent_of_code_2022/jdtls/bin:$PATH"
  '';
}
