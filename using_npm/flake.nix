{
  description = "mystmd flake using NPM";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; };

  outputs = { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nodeEnvPkgs = with pkgs; [
            nodejs_24 # Required for myst
            bun
          ];
          documentationPkgs = with pkgs; [
            typst
          ];
          allPackages = nodeEnvPkgs ++ documentationPkgs;
        in {
          default = pkgs.mkShell {
            packages = allPackages;

            shellHook = ''
              # Inspired by: https://github.com/miklevin/python_nix_flake/blob/main/flake.nix#L138
              export LD_LIBRARY_PATH=${
                pkgs.lib.makeLibraryPath allPackages
              }:$LD_LIBRARY_PATH
              # https://github.com/NixOS/nixpkgs/issues/374125#issuecomment-2593856843
              unset SOURCE_DATE_EPOCH
            '';
          };
        });
    };
}
