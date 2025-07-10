{
  description = "Natrix - Take the RED PILL!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfiguration.default = self.nixosConfigurations.hyprnix;

    nixosConfigurations.hyprnix = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux"; # legacy option, already defined in hardware-configuration.nix
      modules = [
        ./configuration.nix
	./hardware-configuration.nix
	./virtualization.nix
      ];
    };
  };
}
