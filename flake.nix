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
              mkdir -p $out
              cp dist/npm/package.json $out/
              cp dist/npm/LICENSE $out/
              cp dist/npm/README.md $out/
              cp -r dist/npm/esm $out/
              cp -r dist/npm/script $out/
              cp -r dist/npm/css $out/
              cp -r dist/npm/less $out/
              cp -r dist/npm/scss $out/

              rm -f $out/esm/_dnt.test_shims.* $out/esm/mod.test.*
              rm -f $out/script/_dnt.test_shims.* $out/script/mod.test.*
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
