{
  description = "Isotope: Work with noise functions from Elixir";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir_ls
            elixir_1_14

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
