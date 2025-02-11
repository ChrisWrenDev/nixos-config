{
  stdenv,
  lib,
}: let
  awesome = ./awesome;
in
  stdenv.mkDerivation {
    pname = "awesome-wm-config";
    version = "0.1.0";

    buildCommand = ''
      mkdir -p $out
      cp -r ${awesome}/* "$out/"
    '';

    meta = with lib; {
      description = "awesome wm config";
      homepage = "https://chriswren.dev";
      platforms = platforms.all;
      license = licenses.gpl3;
    };
  }
