{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      bat
      bottom
      eza
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
      yazi
    ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };
  };
}
