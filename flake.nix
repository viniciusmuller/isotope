{
  description = "Isotope: Work with noise functions from Elixir";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        my-elixir = (pkgs.beam.packagesWith pkgs.erlangR24).elixir.override {
          version = "1.12.1";
          sha256 = "sha256-gRgGXb4btMriQwT/pRIYOJt+NM7rtYBd+A3SKfowC7k=";
          minimumOTPVersion = "22";
        };
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir_ls
            my-elixir
            rebar3

            rust-analyzer
            cargo
            rustc
            clippy
            rustfmt
          ];
        };
      }
    );
}
