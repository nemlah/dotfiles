function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
 
function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

__shlvl_ps1() {
  if [[ $SHLVL -gt 1 ]]; then
    printf ${1-'%s'} $SHLVL
  fi
}
 
PS1="${TITLEBAR}\
$BLUE[$RED\$(date +%H:%M)$BLUE]\
$BLUE[$WHITE\u:\w$GREEN\$(parse_git_branch)$BLUE]\
$GREEN\$i\
$(__shlvl_ps1 "$BLUE(%s)") \[\033[0m\]"
PS2='> '
PS4='+ '
}
proml

export PATH=/usr/local/bin:/usr/local/git/bin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH
export PYTHONPATH="/usr/local/lib/python2.6/site-packages/:$PYTHONPATH"
export EDITOR='vim'  #Command line
export GIT_EDITOR='vim'
export SKROUTZSTORE_ENV='development'

alias gitlog='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
    
if [ -f  /usr/local/git/contrib/completion/git-completion.bash ]; then
     .  /usr/local/git/contrib/completion/git-completion.bash
fi

#eval `ssh-agent`                                                                                        
#ssh-add  

alias lsa='ls -lah'
alias tunnelthrash='ssh -N thrash -L 27017:localhost:27017'
alias bc='bundle exec'


if [[ -s /Users/nemlah/.rvm/scripts/rvm ]] ; then source /Users/nemlah/.rvm/scripts/rvm ; fi
