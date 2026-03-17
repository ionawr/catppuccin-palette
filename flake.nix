{
  description = "Catppuccin Palettes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: let
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
              deno task build:npm
            '';

            installPhase = ''
              rm -rf dist/npm/node_modules dist/npm/package-lock.json
              cp -r dist/npm $out
            '';

            outputHashAlgo = "sha256";
            outputHashMode = "recursive";
            outputHash = "sha256-RtWQuhVpbz2Viq4fw5CINlMLvT3G/tqDf+UnYLdy1/4=";
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
            outputHash = "sha256-ed5w9LqQEpMyzA6Qnnse+bW54Kgj/55BjB95679irv4=";
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
