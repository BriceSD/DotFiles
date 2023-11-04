# We add pkgs since it's available as an argument, thanks to our inputs
{ pkgs, ... }: {
  # This is required information for home-manager to do its job
  home = {
    stateVersion = "23.11";
    username = "brice";
    homeDirectory = "/home/brice";
    # Then we add the packages we want in the array using pkgs.<name>
    packages = with pkgs; [
      git
      gh
      gh-dash
      neovim
      starship
      fishPlugins.sdkman-for-fish
      kitty
      ripgrep
      i3
      ranger
      lazygit
      lazydocker
      tmux
      feh
      zathura
      tridactyl-native
      conky
    ];
    # Tell it to map everything in the `config` directory in this
    # repository to the `.config` in my home directory
    file.".config" = { source = ./config; recursive = true; };
    file.".fonts" = { source = ./fonts; recursive = true; };
    file.".local" = { source = ./scripts; recursive = true; };
    file."." = { source = ./keyboard; recursive = true; };
    file.".bashrc" = { source = ./.bashrc; };
    file.".bash_profile" = { source = ./.bash_profile; };
    file.".zshrc" = { source = ./.zshrc; };
    file.".zsh_profile" = { source = ./.zsh_profile; };
    file.".xinitrc" = { source = ./.xinitrc ; };
    file.".conkyrc" = { source = ./.conkyrc ; };
  };
  # This is to ensure programs are using ~/.config rather than
  # /Users/<username/Library/whatever
  xdg.enable = true;

  programs.home-manager.enable = true;
  # I use fish, but bash and zsh work just as well here. This will setup
  # the shell to use home-manager properly on startup, neat!
  programs.fish.enable = true;
}
