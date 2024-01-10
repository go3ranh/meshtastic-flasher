{
  description = "DevShell für Platformio und Esptool";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = all@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
				lib = nixpkgs.lib;
			in
			rec {
				packages = {
					esptool = pkgs.python3Packages.buildPythonPackage rec{
						pname = "esptool";
						version = "4.6.2";
						buildInputs = with pkgs.python3Packages; [ ];
						doCheck = false;
						src = pkgs.python3Packages.fetchPypi {
							pname = pname;
							version = version;
							sha256 = "sha256-VJ75Pu9C7n6UYs5aU8Ft96DHHZGz934Z7BV0mATN8wA=";
						};
					};

				};
				devShells = {
					pyesptool = pkgs.mkShell {
						buildInputs = with pkgs; [
							(python3.withPackages (ps: [
								ps.pip
								ps.virtualenv
								ps.pyserial
								self.packages.${system}.esptool
							]))
							platformio
						];
					};
				};
				formatter = pkgs.nixpkgs-fmt;
			});
}
