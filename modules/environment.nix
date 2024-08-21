{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    promptInit = ''
      	    if [ -n "''${commands[fzf-share]}" ]; then
      	      source "''$(fzf-share)/key-bindings.zsh"
      	      source "''$(fzf-share)/completion.zsh"
      	    fi
      	    compinit
      	  '';
  };

  environment = {
    systemPackages = with pkgs; [
      bat
      bottom
      cachix
      datadog-agent
      fd
      file
      fzf
      git
      git-lfs
      helix
      jq
      kitty
      neofetch
      tree
      zellij
    ];

    variables = {
      PS1 = "%d $ ";
      PROMPT = "%d $ ";
      RPROMPT = "";
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };

    # required for zsh autocomplete
    pathsToLink = [ "/share/zsh" ];
  };
}
