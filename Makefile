# NIX_SSHOPTS='-i poisonphang-val' 
val:
	nixos-rebuild switch --no-build-nix --target-host root@testnet.val.poisonphang.com --use-substitutes --flake ./#poisonphang-val --show-trace
seed:
	nixos-rebuild switch --no-build-nix --target-host root@testnet.seed.poisonphang.com --use-substitutes --flake ./#poisonphang-seed --show-trace

ssh-val:
	ssh root@testnet.val.poisonphang.com

ssh-seed:
	ssh root@testnet.seed.poisonphang.com
