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

    # virtualization
    qemu
    virt-manager

    # for herbsluftwm
    lemonbar
    # siji
    # conky
  ];
  home.stateVersion = "24.05";
}
