{
  description = "Example kickstart NixOS desktop environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, home-manager, nixpkgs, nixpkgs-unstable, ... }: 

  let
    nixos-system = import ./system/nixos.nix {
      inherit inputs;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      username = "sushi";
      password = "root";
  };
  in {
    nixosConfigurations = {
      default = nixos-system "x86_64-linux";
    };
  };
}
