HISTFILE=${ZDOTDIR}/history
DIRSTACKFILE=${ZDOTDIR}/.zdirs
HISTSIZE=10000
SAVEHIST=100000
TERM=xterm-256color

# reduce escape key mode change delay from .4s to .1s
export KEYTIMEOUT=1

# vim keybindings
bindkey -v

# export gopath
export GOPATH=~/repo/godev

# add bin, cabal, and roswell if the paths exist
[[ -d "${HOME}/bin" ]] && export PATH="${HOME}/bin:${PATH}"
#[[ -d "${HOME}/.cabal/bin" ]] && export PATH="${HOME}/.cabal/bin:${PATH}"
[[ -d "${HOME}/.local/bin" ]] && export PATH="${HOME}/.local/bin:${PATH}"
[[ -d "${HOME}/.roswell/bin" ]] && export PATH="${HOME}/.roswell/bin:${PATH}"
[[ -d "${HOME}/.gem/ruby/2.3.0/bin" ]] && export PATH="${HOME}/.gem/ruby/2.3.0/bin:${PATH}"
[[ -d "${HOME}/repo/godev/bin" ]] && export PATH="${HOME}/repo/godev/bin:${PATH}"

# aliases
[[ -f ~/.config/zsh/aliases ]] && source ~/.config/zsh/aliases

# tokens
[[ -f ~/.config/zsh/keys ]] && source ~/.config/zsh/keys

fpath+=$ZDOTDIR/completions

# python pirtualenv in prompt
function virtual_env_prompt () {
        REPLY=${VIRTUAL_ENV+${VIRTUAL_ENV:t} }
}

grml_theme_add_token virtual-env -f virtual_env_prompt
zstyle ':prompt:grml:left:setup' items rc virtual-env change-root user at host path vcs percent
systemctl --user import-environment PATH
