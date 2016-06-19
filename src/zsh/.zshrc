HISTFILE=${ZDOTDIR}/history
DIRSTACKFILE=${ZDOTDIR}/.zdirs
HISTSIZE=10000
SAVEHIST=100000
TERM=xterm-256color

# reduce escape key mode change delay from .4s to .1s
export KEYTIMEOUT=1

# vim keybindings
bindkey -v

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
