HISTFILE=${ZDOTDIR}/history
DIRSTACKFILE=${ZDOTDIR}/.zdirs
HISTSIZE=10000
SAVEHIST=100000
TERM=xterm-256color

# reduce escape key mode change delay from .4s to .1s
export KEYTIMEOUT=1

bindkey -v
alias left='xrandr --output VGA1 --auto --left-of LVDS1 --rotate left'
alias right='xrandr --output VGA1 --auto --right-of LVDS1 --rotate left'
alias normal='xrandr --output VGA1 --auto --left-of LVDS1 --rotate normal'
alias off='xrandr --output VGA1 --off --output LVDS1 --auto'

alias mntflash='sudo mount -o gid=lkirk,fmask=112,dmask=002 /dev/sdb1 /mnt/lkirk'
alias umntflash='sudo umount /mnt/lkirk'

# add bin,cabal to path
[[ -d ${HOME}/bin ]] && export PATH="${HOME}/bin:${PATH}"
[[ -d ${HOME}/.cabal/bin ]] && export PATH="${HOME}/.cabal/bin:${PATH}"

# aliases
[[ -f ~/.config/zsh/aliases ]] && source ~/.config/zsh/aliases


# python pirtualenv in prompt
function virtual_env_prompt () {
        REPLY=${VIRTUAL_ENV+${VIRTUAL_ENV:t} }
}
grml_theme_add_token virtual-env -f virtual_env_prompt
zstyle ':prompt:grml:left:setup' items rc virtual-env change-root user at host path vcs percent
