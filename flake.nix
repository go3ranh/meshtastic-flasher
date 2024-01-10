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
						version = "4.7.0";
						buildInputs = with pkgs.python3Packages; [ ];
						doCheck = false;
						src = pkgs.python3Packages.fetchPypi {
							pname = pname;
							version = version;
							sha256 = "sha256-AUVOaeHvNgEhXbg/8ssfx57OZ9JLDl1D1FG0EER8SJM=";
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
								ps.intelhex
								self.packages.${system}.esptool
							]))
							platformio
						];
					};
				};
				formatter = pkgs.nixpkgs-fmt;
			});
}
