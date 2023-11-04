#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -e /home/brice/.nix-profile/etc/profile.d/nix.sh ]; then . /home/brice/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
