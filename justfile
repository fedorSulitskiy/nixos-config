default:
    @just --list

# Build & Switch an impure configuration
[group("Build")]
impure-rebuild-switch:
	@sudo nixos-rebuild switch --impure

# Build & Switch a pure configuration
[group("Build")]
pure-rebuild-switch:
	@sudo nixos-rebuild switch

# List the last 5 generations
[group("Build")]
list-generations:
    @sudo nixos-rebuild list-generations | head -5

# Delete all the garbage
[group("Nix-ops")]
clean-garbage:
    @sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
    @nix-collect-garbage

# Update nix flake
[group("Nix-ops")]
update:
	@nix flake update
