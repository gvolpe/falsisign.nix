{ pkgs, falsisign-src, custom-rotation ? "seq .1 .1 .5" }:

with pkgs;

let
  makeDerivation = { name, prePostFixup ? "" }:
    let
      fixedPath = "${lib.makeBinPath ([ coreutils file ghostscript imagemagick ] ++ lib.optionals (name == "falsisign") [ pdftk ])}";
    in
    stdenv.mkDerivation {
      pname = name;
      version = "0.1.0";

      nativeBuildInputs = [ makeWrapper ];

      buildInputs = [ coreutils file ghostscript pdftk imagemagick ];

      src = falsisign-src;

      installPhase = ''
        mkdir -p $out/bin
        cp $src/${name}.sh $out/bin/${name}
        chmod +x $out/bin/${name}
      '';

      postFixup = prePostFixup + ''
        # replace bash
        substituteInPlace $out/bin/${name} --replace '#!/bin/bash' '#! ${bash}/bin/bash'

        # fix path
        wrapProgram $out/bin/${name} --prefix PATH : ${fixedPath}
      '';

      meta = with lib; {
        homepage = "https://gitlab.com/edouardklein/falsisign";
        license = licenses.wtfpl;
        description = "Command-line tool to simulate a document print-sign-and-scan process. Save trees, ink, time, and stick it to the bureaucrats!";
        maintainers = [ maintainers.gvolpe ];
        platforms = platforms.all;
      };
    };
in
{
  falsisign = makeDerivation {
    name = "falsisign";
    prePostFixup = ''
      # apply custom rotation range - 'seq .1 .1 .5' is a much saner value than the default IMO (it reduces the rotation)
      substituteInPlace $out/bin/falsisign --replace 'seq 0 .1 2' '${custom-rotation}'
    '';
  };

  signdiv = makeDerivation {
    name = "signdiv";
  };
}
