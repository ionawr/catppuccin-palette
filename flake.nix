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
            outputHash = "sha256-ObSSLWjdXFn81T6f2iYGk1ONIkQTN2o2yb+eHl/so7g=";
          };

          json = pkgs.runCommand "catppuccin-palette-json" {} ''
            cp ${inputs.self}/palette.json $out
          '';
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
