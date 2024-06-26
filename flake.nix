{
  description = "An Emacs major mode for editing Nix expressions, powered by tree-sitter.";

  outputs = {
    systems,
    nixpkgs-unstable,
    pre-commit-nix,
    ...
  }: let
    supportedSystems = import systems;
    forAllSystems = nixpkgs-unstable.lib.genAttrs supportedSystems;
  in {
    devShells = forAllSystems (system: let
      pre-commit-check = pre-commit-nix.lib.${system}.run {
        src = ./.;

        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          commitizen.enable = true;
        };
      };
    in {
      default = nixpkgs-unstable.legacyPackages.${system}.mkShell {
        name = "nix-ts-mode-shell";

        packages = with nixpkgs-unstable.legacyPackages.${system}; [cask python311];

        shellHook = ''
          ${pre-commit-check.shellHook}
        '';
      };
    });
  };

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    pre-commit-nix.url = "github:cachix/pre-commit-hooks.nix";
  };
}
