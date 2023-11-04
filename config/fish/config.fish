starship init fish | source

# not working
#fish_config theme choose "kanagawa"

set VIM "nvim"
abbr --add v nvim
abbr --add r ranger
abbr --add t tmux

set -Ux EDITOR nvim
set -x XDG_CONFIG_HOME $HOME/.config

set -x GIT_EDITOR $VIM
set -x DOTFILES $HOME/dotfiles
set -x KALEIDOSCOPE_DIR $HOME/projects/Kaleidoscope

set -x EDITOR $VIM
set -x VISUAL_EDITOR $VIM
set -x PAGER nvimpager

set -g __sdkman_custom_dir $HOME/.sdkman

set -U fish_greeting # disable fish greeting
set -U fish_key_bindings fish_vi_key_bindings

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.cabal/bin
fish_add_path $HOME/.ghcup/bin

# Where should I put you?
#bindkey -s ^f "tmux-sessionizer\n"

bind \cf 'tmux-sessionizer'
bind -M insert \cf 'tmux-sessionizer'

if status is-interactive
    # Commands to run in interactive sessions can go here

end

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end
