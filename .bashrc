if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

xhost +local:root > /dev/null 2>&1

#complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete

#export XDG_CURRENT_DESKTOP=KDE            # ensure that the installed KDE programs are used
export LANG=en_GB.UTF-8
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export JAVA_FONTS=/usr/share/fonts/TTF
export EDITOR=/usr/bin/vim
export BROWSER=/usr/bin/vivaldi
export MAN_POSIXLY_CORRECT=1

eval "$(dircolors $HOME/.dircolors)"

alias ls='ls -h --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
cdls() {
  cd $1
  ls
}
alias cl='cdls'
alias tree='tree --dirsfirst'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='vim PKGBUILD'
alias fixit='sudo rm -f /var/lib/pacman/db.lck'
alias upgrade='yaourt -Syua'
alias con='vim ~/.config/i3/config'
alias comp='vim .config/compton.conf'
alias men='mousepad ~/.i3/mygtkmenu.conf'
alias xflock='light-locker-command -l'
alias printer='system-config-printer'
alias hexchat='GTK2_RC_FILES=/usr/share/themes/Arc-Dark/gtk-2.0/gtkrc hexchat'
#alias subl='GTK2_RC_FILES=/usr/share/themes/Arc-Dark/gtk-2.0/gtkrc subl3'
alias eclipse='SWT_GTK3=0 eclipse'
alias steam='STEAM_RUNTIME=0 steam'
alias dirs='dirs -v'
alias pdflatex='pdflatex -halt-on-error -interaction=nonstopmode'
alias virtualbox='VirtualBox'
#eval $(thefuck --alias)

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export PATH=$PATH:/home/peter/.nimble/bin
# prompt
#PS1='[\u@\h \W]\$ '
#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
#PS1="\[\033[01;37m\]\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]0\"; else echo \"\[\033[01;31m\]\$?\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='\[\007\e[0;32m\][\u \[\e[1;34m\]\w\[\e[0;32m\]$(parse_git_branch) ]\n\[\e[1;32m\]\$ \[\e[0m\]'
PROMPT_COMMAND='es=$?; [[ $es -eq 0 ]] && unset error || error=$(echo -e " $es ")'
PS1="\[\e[1;41m\]\$error\[\e[0m\]${PS1}"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
