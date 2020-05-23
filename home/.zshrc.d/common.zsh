#允许在交互模式中使用注释
setopt INTERACTIVE_COMMENTS

#启用自动 cd，输入目录名回车进入目录
setopt AUTO_CD

#扩展路径
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word

#禁用 core dumps
# limit coredumpsize 0

#键绑定风格 (e)macs|(v)i
bindkey -e
#设置 [DEL]键 为向后删除
bindkey "\e[3~" delete-char

#以下字符视为单词的一部分
WORDCHARS='-*[]~#%^<>{}'

###### title
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
   preexec () { print -Pn "\e]0;${PWD/$HOME/\~}: $1\a" }
   ;;
esac

alias rm='rm -i'
alias mv='mv -i'
alias ll='ls -alh'
alias du='du -h'
alias df='df -h'
alias mkdir='mkdir -p'
alias r='grep --color=auto'
alias diff='diff -u'
alias e='code'
alias t='tmux'
alias tl='tmux list-sessions'
alias ta='tmux attach -t'
alias x='export'
alias o='echo'

function take() {
    mkdir -p $@ && cd ${@:$#}
}
function px { ps aux | grep -i "$*" }
function p { pgrep -a "$*" }
__default_indirect_object="local z=\${@: -1} y=\$1 && [[ \$z == \$1 ]] && y=\"\$default\""


if [ -x "$(command -v nvim)" ]; then
    alias v='nvim'
elif [ -x "$(command -v vim)" ]; then
    alias v='vim'
else
    alias v='vi'
fi

export TIME_STYLE=long-iso
alias n='date +%y%m%d%H%M%S'
alias now='date -Iseconds'
