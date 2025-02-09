{
  stdenv,
  lib,
}: let
  nvim = ./nvim;
in
  stdenv.mkDerivation {
    pname = "nvim-config";
    version = "2.5.0";

    buildCommand = ''
      mkdir -p $out
      cp -r ${nvim}/* "$out/"
    '';

    meta = with lib; {
      description = "nvim config";
      homepage = "https://chriswren.dev";
      platforms = platforms.all;
      license = licenses.gpl3;
    };
  }
