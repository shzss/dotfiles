#aliases

##git
alias gits="git status"
alias gita="git add"
alias gitc="git commit"
alias gitp="git push" 
alias c="clear"

# git branch
parse_git_branch() {
     branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '- ('$branch')'
  fi
}
COLOR_DEF=$'%f'
COLOR_USR=$'%F{114}'
COLOR_DIR=$'%F{114}'
COLOR_GIT=$'%F{39}'
NEWLINE=$'\n'
setopt PROMPT_SUBST
export PROMPT=' ${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE} $ '

