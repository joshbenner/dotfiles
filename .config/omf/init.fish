set my_user_paths ~/bin ~/go/bin ~/.composer/vendor/bin /usr/local/sbin ~/.local/bin /usr/local/go/bin ~/bin/google-cloud-sdk/bin

for mypath in $my_user_paths
  if test -d $mypath
    set found_user_paths $found_user_paths $mypath
  end
end

set -U fish_user_paths $found_user_paths
set -e my_user_paths
set -e mypath
set -e found_user_paths

set -gx GOPATH ~/go

set -gx LSCOLORS dxgxcxdxcxegedabagacad

#set -gx DOCKER_HOST "tcp://localhost:2375"

function grep
  command grep --color=auto --exclude-dir=\.svn --exclude-dir=\.git $argv
end

function ll
  ls -lha $argv
end

function l
  ls -lh $argv
end

if test -e "/usr/local/bin/colordiff"
  function diff
    colordiff $argv
  end
end

function dc
  docker-compose $argv
end

function grp
  grep -sHirn $argv .
end

# set fish_function_path $fish_function_path "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/fish"
# powerline-setup

function fish_title
  echo $USER'@'(hostname -s) (prompt_pwd)
end

eval (python -m virtualfish)

if test -e "$HOME/.config/fish/local.fish"
  . "$HOME/.config/fish/local.fish"
end
