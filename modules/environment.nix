{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      bat
      bottom
      fd
      file
      fzf
      git
      git-lfs
      helix
      jq
      kitty
      neofetch
      nushell
      tree
    ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };
  };
}
