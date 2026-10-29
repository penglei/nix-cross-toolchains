{
  description = "cross toolchains based on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      systems = {
        "aarch64-darwin" = [
          "aarch64-unknown-linux-gnu"
          "aarch64-unknown-linux-musl"
          "x86_64-unknown-linux-gnu"
          "x86_64-unknown-linux-musl"
        ];
        "aarch64-linux" = [
          "x86_64-unknown-linux-gnu"
          "x86_64-unknown-linux-musl"
        ];
        "x86_64-linux" = [
          "x86_64-unknown-linux-musl"
          "aarch64-unknown-linux-gnu"
          "aarch64-unknown-linux-musl"
        ];
      };

      mkCrossSystemPkgs =
        system:
        let
          makeHostPkg =
            hostSystemTriple:
            (import nixpkgs) {
              # inherit system; //deprecated
              localSystem = { inherit system; };
              crossSystem.config = hostSystemTriple;
            };

          systemCrossPkgs = builtins.map (hostSystemTriple: {
            name = hostSystemTriple;
            value = makeHostPkg hostSystemTriple;
          }) systems.${system};

          crossPkgs = builtins.listToAttrs (systemCrossPkgs);

          staticMuslCrossPkgs = builtins.listToAttrs (
            builtins.map (name: {
              name = "${name}-static";
              value = crossPkgs.${name}.pkgsStatic;
            }) (builtins.filter (name: (builtins.match ".+musl$" name) != null) (builtins.attrNames crossPkgs))
          );
          allCrossPkgs = crossPkgs // staticMuslCrossPkgs;
        in
        allCrossPkgs;

      mkCrossSystemShells =
        system: builtins.mapAttrs (_: pkgs: pkgs.mkShell { }) (mkCrossSystemPkgs system);

    in

    flake-utils.lib.eachSystem (builtins.attrNames systems) (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              llvm_18
              llvmPackages_18.clang-unwrapped
              llvmPackages_18.lld
            ];
          };
        }
        // mkCrossSystemShells system;
      }
    );
}
