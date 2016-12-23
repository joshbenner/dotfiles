set my_user_paths ~/bin ~/golang/go/bin ~/go/bin ~/.composer/vendor/bin /usr/local/sbin ~/.local/bin /usr/local/go/bin ~/bin/go/bin  ~/bin/google-cloud-sdk/bin

for mypath in $my_user_paths
  if test -d $mypath
    set found_user_paths $found_user_paths $mypath
  end
end

set -U fish_user_paths $found_user_paths
set -e my_user_paths
set -e mypath
set -e found_user_paths

if test -d ~/golang/go
  set -gx GOPATH ~/golang/go
else if test -d ~/go
  set -gx GOPATH ~/go
end

set -gx LSCOLORS dxgxcxdxcxegedabagacad

#set -gx DOCKER_HOST "tcp://localhost:2375"

# Tell theme to always show user/host
set -g theme_display_user yes

function grep --wraps grep
  command grep --color=auto --exclude-dir=\.svn --exclude-dir=\.git $argv
end

function ll --wraps ls
  ls -lha $argv
end

function l --wraps ls
  ls -lh $argv
end

if test -e "/usr/local/bin/colordiff"
  function diff --wraps colordiff
    colordiff $argv
  end
end

function dc --wraps docker-compose
  docker-compose $argv
end

function grp --wraps grep
  grep -sHirn $argv .
end

function gitlog
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
end

function scu --wraps systemctl
  systemctl --user $argv
end

# set fish_function_path $fish_function_path "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/fish"
# powerline-setup

function fish_title
  echo $USER'@'(hostname -s) (prompt_pwd)
end

eval (python -m virtualfish auto_activation)

if test -e "$HOME/.config/fish/local.fish"
  . "$HOME/.config/fish/local.fish"
end
