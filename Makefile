# NIX_SSHOPTS='-i poisonphang-val' 
poisonphang-val:
	GIT_LFS_SKIP_SMUDGE=1 nixos-rebuild switch --flake .#poisonphang-val --target-host root@testnet.val.poisonphang.com -L --show-trace
poisonphang-seed:
	GIT_LFS_SKIP_SMUDGE=1 nixos-rebuild switch --flake .#poisonphang-seed --target-host root@testnet.seed.poisonphang.com -L --show-trace
