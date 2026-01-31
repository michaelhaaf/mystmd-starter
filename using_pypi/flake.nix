{
  description = "mystmd flake using pypi";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; };

  outputs = { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pythonEnvPkgs = with pkgs; [ python314 uv ];
          nodeEnvPkgs = with pkgs;
            [
              nodejs_24 # Required for myst
            ];
          documentationPkgs = with pkgs; [ typst ];
          pythonCLibraries = with pkgs; [
            # On Nix at least, a few C-libraries are needed explicitly for LD path.
            gcc
            stdenv.cc.cc.lib
            zlib
            libglvnd
            libxkbcommon
            fontconfig
            libx11
            glib
            freetype
            zstd
            dbus
            libxcb-cursor
            wayland
          ];
          allPackages = pythonEnvPkgs ++ nodeEnvPkgs ++ documentationPkgs
            ++ pythonCLibraries;
        in {
          default = pkgs.mkShell {
            packages = allPackages;

            shellHook = ''
              # Inspired by: https://github.com/miklevin/python_nix_flake/blob/main/flake.nix#L138
              export LD_LIBRARY_PATH=${
                pkgs.lib.makeLibraryPath allPackages
              }:$LD_LIBRARY_PATH
              unset PYTHONPATH
              # https://github.com/NixOS/nixpkgs/issues/374125#issuecomment-2593856843
              unset SOURCE_DATE_EPOCH
              uv sync
              . .venv/bin/activate
            '';
          };
        });
    };
}
