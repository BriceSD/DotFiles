# We add pkgs since it's available as an argument, thanks to our inputs
{ pkgs, ... }: {
  # This is required information for home-manager to do its job
  home = {
    stateVersion = "23.11";
    username = "brice";
    homeDirectory = "/home/brice";
    packages = with pkgs; [
    # Shared
      git
      gh
      gh-dash
      delta
      zsh
      gcc
      wget
      unzip
      nodejs_20
      fzf
      neovim
      starship
      fishPlugins.sdkman-for-fish
      fishPlugins.fzf-fish
      fishPlugins.colored-man-pages
      fishPlugins.z
      fishPlugins.plugin-git
      ripgrep
      ranger
      lazygit
      lazydocker
      tmux
      gitmux
      feh
      zathura
      tridactyl-native
      #kitty # kitty can be tricky, better to install manually

      # Linux
      conky
      i3

      # Mac x86_64
      # yabai
      # skhd
      # iterm2
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
  };
  # This is to ensure programs are using ~/.config rather than
  # /Users/<username/Library/whatever
  xdg.enable = true;

  programs.home-manager.enable = true;
  # I use fish, but bash and zsh work just as well here. This will setup
  # the shell to use home-manager properly on startup, neat!
  programs.fish.enable = true;
}
