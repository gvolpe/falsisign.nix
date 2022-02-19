# falsisign.nix

Nix derivation for [falsisign](https://gitlab.com/edouardklein/falsisign), a command-line tool to simulate a document print-sign-and-scan process. Save trees, ink, time, and stick it to the bureaucrats!

## Usage

There are two flake applications: `falsisign` and `signdiv`. The latter is used to generate the signatures:

```console
$ nix run github:gvolpe/falsisign.nix#signdiv signatures.pdf
...
+ for start_x in 0 750 1500
+ rm -rf /tmp/falsisign-N5qS9QAAr9.
```

The former is the default app to apply the signature and output the final "scanned" file.

```console
$ nix run github:gvolpe/falsisign.nix#falsisign -- \
    -d document.pdf \
    -s Signature_example \
    -x 1000 -y 2500 \
    -p '1' \
    -o scanned.pdf
...
+ gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages -dCompressFonts=true -r150 -sOutputFile=scanned.pdf /tmp/falsisign-gDhjKWH36F/document_large.pdf
+ rm -rf /tmp/falsisign-gDhjKWH36F
```
