local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local user_host='%{$terminfo[bold]$fg[green]%}%n@%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local rvm_ruby=''
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="╭─ [⌚ ${time_enabled}] ${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
╰─%B$%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"


LASTCMD_START=0
function microtime()
{
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date +'%s' 
  else
    date +'%s.%N' 
  fi 
}


#called before user command
function preexec(){
  #set_titlebar $TITLEHOST\$ "$1"
  LASTCMD_START=`microtime` 
  LASTCMD="$1"
}

#called after user cmd
function precmd(){ 
  if [[ "$LEGACY_ZSH" != "1" ]]
  then
    #set_titlebar "$TITLEHOST:`echo "$PWD" | sed "s@^$HOME@~@"`"
    local T=0 ; (( T = `microtime` - $LASTCMD_START ))
    if (( $LASTCMD_START > 0 )) && (( T>1 ))
    then
      T=`echo $T | head -c 10` 
      LASTCMD=`echo "$LASTCMD" | grep -ioG '^[a-z0-9./_-]*'`
      timer="$terminfo[bold]$fg[yellow] $LASTCMD took $T seconds $reset_color"
      echo "$timer"
    fi
    LASTCMD_START=0
  fi
}

