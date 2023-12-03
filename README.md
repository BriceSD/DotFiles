# Dotfiles
## Using Nix
I'm using `nix` to manage my dotfiles, to install it: 
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

The command to run the first time around is:

```sh
nix run github:nix-community/home-manager -- switch --flake .
```

After the first run, home-manager is available directly, and so you can do:

```sh
home-manager switch --flake .
```

I followed [this tutorial](https://dev.to/synecdokey/nix-on-macos-2oj3).

## Add your Mac or Linux specific packages
### All 
* Kitty
* Lua Hererocks for nvim plugin luasnip ?
* Tridactyl (See :help ????)

### Linux
* i3


### Mac
* Yabai
* skhd
