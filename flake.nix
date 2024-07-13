{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem (system:
			let pkgs = import nixpkgs {
				inherit system;
			};
			flatpak-cargo-vendor = pkgs.stdenvNoCC.mkDerivation {
				name = "flatpak-cargo-vendor";
				src = pkgs.fetchFromGitHub {
					owner = "flatpak";
					repo = "flatpak-builder-tools";
					rev = "338ce9c6512d49d98ae9a508d219ffe19b5144e8";
					sha256 = "sha256-O4tXlkR7FmoqMC3jZZGrO19Ds0KUV07bWLqMMrFYL7w=";
				};

				buildInputs = with pkgs; [ (python3.withPackages (p: with p; [
					aiohttp
					toml
				])) ];

				buildPhase = "mkdir $out/bin -p && mv cargo/flatpak-cargo-generator.py $out/bin/flatpak-cargo-vendor";
				installPhase = "patchShebangs $out/bin/flatpak-cargo-vendor";
			};
			manifest = builtins.fromJSON (builtins.readFile ./io.github.urlordjames.GreenUpdater.json);
			green-updater-commit = (builtins.elemAt (builtins.elemAt manifest.modules 0).sources 0).commit;
			cargo-lock = pkgs.stdenvNoCC.mkDerivation {
				name = "cargo-lock";
				src = pkgs.fetchFromGitHub {
					owner = "urlordjames";
					repo = "green-updater";
					rev = green-updater-commit;
					sha256 = "sha256-l/ywDCd9p7hiDaENpzMhcQMiLcLbHbjF5LW2p3ViLGo=";
				};

				buildPhase = "mkdir $out && cp Cargo.lock $out/Cargo.lock";
			}; in {
				devShells.default = pkgs.mkShell {
					packages = with pkgs; [
						flatpak-builder
						flatpak-cargo-vendor
						appstream
					];

					shellHook = "export CARGO_LOCK=${cargo-lock}/Cargo.lock";
				};
			}
		);
}
