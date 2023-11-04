# Dotfiles
## Using Nix
I'm using `nix` to manage my dotfiles now, so the command to run the first time
around is:

```sh
nix run github:nix-community/home-manager -- switch --flake .
```

After the first run, home-manager is available directly, and so you can do:

```sh
home-manager switch --flake .
```

I followed [this tutorial](https://dev.to/synecdokey/nix-on-macos-2oj3).


# Outdated
## Required for installation

* Shell
* Stow : sudo pacman -U https://archive.archlinux.org/packages/s/stow/stow-2.2.2-5-any.pkg.tar.xz
* Lua Hererocks for nvim plugin luasnip ?
* Ranger
* LazyGit

## Config for

* Zsh
* Oh-my-zsh
* Nvim
* Tmux
* Git
* i3
* Tridactyl (firefox extention)
* Feh
* Zathura
* Kitty
 
## Post install configuration
### Nvim 
* :MasonInstall
* :Lazy

### Terminal
* starship
* fish
* fisher

### Git
* git
* lazygit
* gh
* gh dash : gh extension install dlvhdr/gh-dash

### Tmux
* gitmux (install manually ?)

### Tridactyl
* See :help ????
