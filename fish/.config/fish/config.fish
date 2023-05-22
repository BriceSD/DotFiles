if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    alias v="nvim"
export XDG_CONFIG_HOME=$HOME/.config
export GIT_EDITOR=$VIM
export DOTFILES=$HOME/dotfiles
export KALEIDOSCOPE_DIR=$HOME/projects/Kaleidoscope

export EDITOR=$VIM
export VISUAL_EDITOR=$VIM

path+=($HOME/.local/bin/)
path+=($HOME/.cargo/bin/)
fpath+=~/.zfunc
#addToPathFront $HOME/.local/.npm-global/bin
#addToPathFront $HOME/.local/bin
export PATH
end

