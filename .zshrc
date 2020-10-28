# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

path+=$HOME/bin
for gemdir in $HOME/.gem/ruby/*; do
    if [ -d $gemdir/bin ]; then
        path+=$gemdir/bin
    fi
done

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Configure history beyond what oh-my-zsh will do.
# See: https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh
export SAVEHIST=2000000    # Save lots to the file
export HISTSIZE=200000     # Keep some in memory
setopt inc_append_history  # Write history immediately

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf-tab git direnv docker fd fzf kubectl pip pyenv ssh-agent zsh_reload
         zsh-autosuggestions zsh-syntax-highlighting colored-man-pages virtualz)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

# From: https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# macOS/homebrew
[[ -s "/usr/local/etc/grc.zsh" ]] && source /usr/local/etc/grc.zsh
# linux
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# Tell less to only paginage if output exceeds one screen.
export LESS="-F -X $LESS"

# Aliases
if type exa > /dev/null; then
    alias l='exa -Flgh --git --group-directories-first'
    alias ll='exa -Falgh --git --group-directories-first'
fi

grp() {
    grep -sHirn $1 .
}

alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias dc=docker-compose
alias yat="bat -l yaml --pager=never"
alias cssh=i2cssh

# Alias vf=vz because muscle memory keeps using vf.
alias vf=vz

# Local overrides
if [ -d $HOME/.config/zsh/conf.d ]; then
    for file in $HOME/.config/zsh/conf.d/*.zsh; do
        source $file
    done
fi

# Make all path entries unique
typeset -aU path
