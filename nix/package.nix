# FIXME
{ lib
, stdenv
, just
, installShellFiles
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
    ../completions
  ];
in stdenv.mkDerivation {
  name = "jpg";
  src = fs.toSource {
    root = ../.;
    fileset = sourceFiles;
  };
  
  propagatedBuildInputs = [ just ];
  nativeBuildInputs = [ installShellFiles ];
  
  installPhase = ''
    runHook preInstall

    env NIXOS=1 PREFIX="$out" just install
    installShellCompletion ./completions/jpg.{bash,fish,zsh}

    runHook postInstall
  '';
}

