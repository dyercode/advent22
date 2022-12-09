{
  description = "advent 2022";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    dev.url = "github:dyercode/dev";
  };

  outputs = { self, nixpkgs, flake-utils, dev }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              ponyc
              dev.defaultPackage.${system}
            ];
          };
        }
      );
}
