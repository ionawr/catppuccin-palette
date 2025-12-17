{
  description = "Catppuccin Palettes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {self, ...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    systems = lib.systems.flakeExposed;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      inherit systems;

      perSystem = {
        pkgs,
        self',
        ...
      }: {
        packages = {
          default = self'.packages.npm;

          npm = pkgs.stdenv.mkDerivation {
            pname = "catppuccin-palette";
            version = "1.7.1";
            src = inputs.self;

            nativeBuildInputs = with pkgs; [
              deno
              nodejs
              cacert
            ];

            buildPhase = ''
              export HOME=$TMPDIR
              export DENO_DIR=$TMPDIR/deno
              export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
              export NODE_EXTRA_CA_CERTS=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
              deno task build
            '';

            installPhase = ''
              cp -r dist/npm $out
            '';

            outputHashAlgo = "sha256";
            outputHashMode = "recursive";
            outputHash = "sha256-meMlFd8ha2s2YZaz2QjAmaucUSvjW1oBwlgYuV69asI=";
          };

          json = pkgs.stdenv.mkDerivation {
            pname = "catppuccin-palette";
            version = "1.7.1";
            src = inputs.self;

            nativeBuildInputs = with pkgs; [
              deno
              nodejs
              cacert
            ];

            buildPhase = ''
              export HOME=$TMPDIR
              export DENO_DIR=$TMPDIR/deno
              export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
              export NODE_EXTRA_CA_CERTS=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
              deno task generate
            '';

            installPhase = ''
              cp palette.json $out
            '';

            outputHashAlgo = "sha256";
            outputHash = "sha256-//OsJjEOw+Dc9C6MIwswOoOK8cDMo7eFpDwECD3k34Q=";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            deno
            nodejs
          ];
        };
      };
    };
}
