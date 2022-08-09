# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/peter/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Copied from .bashrc
export JAVA_FONTS=/usr/share/fonts/TTF
export EDITOR=/usr/bin/vim
export BROWSER=/usr/bin/vivaldi-stable
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
alias history='fc -l 0'
alias f='find . -name'
alias g='grep -Hnr'
alias rgrep='find . -name "*.rb" -print0 | xargs -0 grep --color=tty -d skip -Hnr'
alias cdg='cd $(git rev-parse --show-toplevel)'
alias build='~/work/meos-pph/meos-pph/dev/vagrant/scripts/build'
alias deploy='~/work/meos-pph/meos-pph/dev/vagrant/scripts/deploy'
alias build-and-deploy='~/work/meos-pph/meos-pph/dev/vagrant/scripts/build-and-deploy'
alias wifipw='sudo grep -r "^psk=" /etc/NetworkManager/system-connections/'

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

# Modified for zsh
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
last_error() {
  es=$?
  [[ $es -eq 0 ]] && echo "" || echo -e "%F{1}▐%f%K{1}$es%k%F{1}▋%f"
}

setopt prompt_subst
PROMPT='$(last_error)%F{2}[%n %B%F{4}%~%F{2}%b$(parse_git_branch) ] %B$%b%f %{%}'
setopt correctall
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1

typeset -g -A key

key[Home]="$terminfo[khome]"
key[End]="$terminfo[kend]"
key[Insert]="$terminfo[kich1]"
key[Backspace]="$terminfo[kbs]"
key[Delete]="$terminfo[kdch1]"
key[Up]="$terminfo[kcuu1]"
key[Down]="$terminfo[kcud1]"
key[Left]="$terminfo[kcub1]"
key[Right]="$terminfo[kcuf1]"
key[PageUp]="$terminfo[kpp]"
key[PageDown]="$terminfo[knp]"

# setup key accordingly
[[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
[[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
[[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
[[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-history
[[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-history
[[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
[[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char
[[ -n "$key[PageUp]"    ]] && bindkey -- "$key[PageUp]"    history-beginning-search-backward
[[ -n "$key[PageDown]"  ]] && bindkey -- "$key[PageDown]"  history-beginning-search-forward


# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Make Ctrl+Backspace delete the last path element
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
bindkey -- '^\b' backward-kill-word

#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt NO_HUP
unsetopt HUP
wd() {
  . /home/peter/bin/wd/wd.sh
}

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    bg
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
