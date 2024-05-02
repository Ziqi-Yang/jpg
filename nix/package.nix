# FIXME
{ lib
, stdenv
, just
}: let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ../jpg
    ../jpg.sh
    ../lib.just
    ../justfile
    ../template_var.just
    ../config.just
    ../completions
    ../LICENSE
  ];
in
stdenv.mkDerivation {
  name = "jpg";
  src = fs.toSource {
    root = ../.;
    fileset = sourceFiles;
  };
  
  nativeBuildInputs = [ just ];
  
  installPhase = ''
    runHook preInstall

    just install

    runHook postInstall
  '';
}

