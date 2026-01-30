impure-rebuild-switch:
	@sudo nixos-rebuild switch --impure

pure-rebuild-switch:
	@sudo nixos-rebuild switch

clean-garbage:
	@nix-collect-garbage

update:
	@nix flake update