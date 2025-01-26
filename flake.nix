{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
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
					rev = "a1eb29c5f3038413ffafd4fea34e62c361c109ad";
					sha256 = "sha256-t8JYNSbPtSEv4ptdfBk6OBvPnXv5Jz0iag7ieoc0fUU=";
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
					sha256 = "sha256-i9oB8KRWLAy8jIze1YmF1qkjXo5mGn3ZkDyCczRZcKc=";
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
