{
  description = "Natrix - Take the RED PILL!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    natrix.url = "github:0xhanu58/natrix?ref=main";
  };

  outputs = { self, nixpkgs }: {

    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations.hyprnix = nixpkgs.lib.mkDefault nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux"; # legacy option, already defined in hardware-configuration.nix
      modules = [
        ./configuration.nix
	./hardware-configuration.nix
      ];
    };
  };
}
