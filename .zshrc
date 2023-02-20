if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    session_type=remote
else
    session_type=local
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

path=($HOME/bin $path)
if [ -e $HOME/.gem/ruby ]; then
    for gemdir in $HOME/.gem/ruby/*; do
        if [ -d $gemdir/bin ]; then
            path+=$gemdir/bin
        fi
    done
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python"
fi

if grep WSL /proc/version > /dev/null; then
    bindkey '^H' backward-kill-word
fi

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
plugins=(asdf fzf-tab git direnv docker fd fzf kubectl pip
         zsh-autosuggestions zsh-syntax-highlighting colored-man-pages virtualz
         virtualenvwrapper)
if [ "$session_type" = "local" ]; then
    plugins+=(ssh-agent)
fi

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  # The list of segments shown on the left. Fill it with the most important segments.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    os_icon                 # os identifier
    context                 # user@hostname
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
    prompt_char             # prompt symbol
)

# The list of segments shown on the right. Fill it with less important segments.
# Right prompt on the last prompt line (where you are typing your commands) gets
# automatically hidden when the input line reaches it. Right prompt above the
# last prompt line gets hidden if it would overlap with left prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    direnv                  # direnv status (https://direnv.net/)
    asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    anaconda                # conda environment (https://conda.io/)
    pyenv                   # python environment (https://github.com/pyenv/pyenv)
    goenv                   # go environment (https://github.com/syndbg/goenv)
    nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
    nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
    nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
    rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
    rvm                     # ruby version from rvm (https://rvm.io)
    fvm                     # flutter version management (https://github.com/leoafarias/fvm)
    luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
    jenv                    # java version from jenv (https://github.com/jenv/jenv)
    plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
    phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
    scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
    haskell_stack           # haskell version from stack (https://haskellstack.org/)
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    terraform               # terraform workspace (https://www.terraform.io)
    aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
    aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
    azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
    gcloud                  # google cloud cli account and project (https://cloud.google.com/)
    google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
    ranger                  # ranger shell (https://github.com/ranger/ranger)
    nnn                     # nnn shell (https://github.com/jarun/nnn)
    vim_shell               # vim shell indicator (:sh)
    midnight_commander      # midnight commander shell (https://midnight-commander.org/)
    nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
    todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
    timewarrior             # timewarrior tracking status (https://timewarrior.net/)
    taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
    time                    # current time
    # =========================[ Line #2 ]=========================
    newline
)

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
[[ -s "/usr/local/etc/grc.zsh" ]] && source /usr/local/etc/grc.zsh < $TTY
# linux
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh < $TTY

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

# Alias pbcopy/pbpaste for Debian-family OS.
if [ -f /etc/debian_version ]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# Local overrides
if [ -d $HOME/.config/zsh/conf.d ]; then
    for file in $HOME/.config/zsh/conf.d/*.zsh; do
        source $file
    done
fi

# Support krew
path=($HOME/.krew/bin $path)

# Make all path entries unique
typeset -aU path

# Disable autocomplete beeps.
unsetopt LIST_BEEP
