{pkgs, ...}: {
  # add home-manager user settings here
  home.packages = with pkgs; [
    git 
    neovim 
    prettierd
    pavucontrol
    shutter
    cider
    tmux
  ];
  home.stateVersion = "24.05";
}
