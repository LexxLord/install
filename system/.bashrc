#shellcheck shell=bash
#/// !/bin/bash
#/// ~/.bashrc
# Version 1.0 (Release)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
#alias ls='lsd --color=auto'
#alias du='ncdu'
#alias top='htop'
alias fd='fd'
#alias find='fd'
alias rm='rm -i'
alias me='mcedit'
alias scv='sudo pacman -Scc --noconfirm'
alias scq='pacman -Qdtq || echo "All Cleared.."'
alias scs='sudo pacman -Rsn $(pacman -Qdtq) --noconfirm'

# XOrg On/Off
alias xon='systemctl enable lightdm-plymouth.service'
alias xoff='systemctl disable lightdm-plymouth.service'

#export loadkeys ru
alias locru='export LANG=ru_RU.UTF-8 && setfont cyr-sun16'
alias locus='export LANG=en_US.UTF-8'
alias locen='export LANG=en_US.UTF-8'

# Set History
#export HISTFILE="~/.hist.my"
export HISTTIMEFORMAT='%F >> %T | '
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="\$*:[A-Z]*:[А-Я]*:[а-я]*:[0-9]*:login:exit:reboot:poweroff:man*:./*"
export HISTSIZE=2000
export HISTFILESIZE=2000

shopt -s histappend

## Correcting
shopt -s cdspell
shopt -s cmdhist
shopt -s lithist

#On record history
#shopt -os history
#Off record history
#shopt -ou history
#No history
#unset HISTFILE

function historymerge { history -n; history -w; history -c; history -r; }
#history -n     - reads all lines from $HISTFILE that may have occurred in a different
#                 terminal since the last carriage return
#history -c     - wipes the buffer so no duplication occurs
#history -r     - re-reads the $HISTFILE, appending to the now blank buffer
#history -w     - writes the updated buffer to $HISTFILE

trap historymerge EXIT

# Set Color
export TERM=xterm-256color

## Text
#CF0="\001$(tput setaf 0)\002"      # Black
CF1="\001$(tput setaf 1)\002"      # Red
CF2="\001$(tput setaf 2)\002"      # Green
#CF3="\001$(tput setaf 3)\002"      # Brown
CF4="\001$(tput setaf 4)\002"      # Blue
#CF5="\001$(tput setaf 5)\002"      # Magenta
CF6="\001$(tput setaf 6)\002"      # Cyan
#CF7="\001$(tput setaf 7)\002"      # Gray light
CF8="\001$(tput setaf 8)\002"      # Gray
CF9="\001$(tput setaf 9)\002"      # Red light
CF10="\001$(tput setaf 10)\002"    # Green light
CF11="\001$(tput setaf 11)\002"    # Yellow
CF12="\001$(tput setaf 12)\002"    # Blue light
CF13="\001$(tput setaf 13)\002"    # Magenta light
#CF14="\001$(tput setaf 14)\002"    # Cyan light
CF15="\001$(tput setaf 15)\002"    # White

## Background
#CB0="\001$(tput setab 0)\002"      # Black
CB1="\001$(tput setab 1)\002"      # Red
#CB2="\001$(tput setab 2)\002"      # Green
#CB3="\001$(tput setab 3)\002"      # Brown
#CB4="\001$(tput setab 4)\002"      # Blue
#CB5="\001$(tput setab 5)\002"      # Magenta
#CB6="\001$(tput setab 6)\002"      # Cyan
#CB7="\001$(tput setab 7)\002"      # Gray light
#CB8="\001$(tput setab 8)\002"      # Gray
#CB9="\001$(tput setab 9)\002"      # Red light
#CB10="\001$(tput setab 10)\002"    # Green light
#CB11="\001$(tput setab 11)\002"    # Yellow
#CB12="\001$(tput setab 12)\002"    # Blue light
#CB13="\001$(tput setab 13)\002"    # Magenta light
#CB14="\001$(tput setab 14)\002"    # Cyan light
#CB15="\001$(tput setab 15)\002"    # White

## Text Mode
CTB="\001$(tput bold)\002"          # Bold
#CTD="\001$(tput dim)\002"           # Half-bright mode
CTC="\001$(tput sgr0)\002"          # Reset

# Functions
### BEGIN LANGUAGE LIBRARY ###
# Russian
russian() {
    LNG_L="Локальный"
	LNG_N="Сетевой"

    LNG_T_T="Терминал"
    LNG_T_N="Имя"
    LNG_T_D="й д."
    LNG_T_W="я н."

    LNG_TSK="задачи"
    LNG_T_Y="г."

    LNG_D_W="Вс"

    # 45 - Зазор между "$LT" и "$RT" в "host()"
    INDENT=$(( $(tput cols) + 45))
}

# English
english() {
    LNG_L="Local"
	LNG_N="Network"

    LNG_T_T="Terminal"
    LNG_T_N="Name"
    LNG_T_D="th d."
    LNG_T_W="th w."

    LNG_D_W="Sun"

    LNG_TSK="tasks"
    LNG_T_Y="y."

    # 39 - Gap between "$LT" and "$RT" on "host()"
    INDENT=$(( $(tput cols) + 39))
}
### END LANGUAGE LIBRARY ###

### BEGIN LANGUAGE SELECT ###
sel_lng(){

    LNG_LNG="$(locale | grep "LANG=" | tr -d "LANG=")"

    case "$(locale | tr '[:lower:]' '[:upper:]')" in
    LANG=RU_RU*)
        russian
        ;;

    *)
        english
        ;;
    esac
}
### END LANGUAGE SELECT ###

USC()
{
    if groups | grep -q 'root'
    then
        CLU="${CF9}"
        CLH="${CF4}"
        SBL="#"
    elif groups | grep -q 'adm\|wheel'
    then
        CLU="${CF10}"
        CLH="${CF4}"
        SBL="$"
    else
        CLU="${CTC}"
        CLH="${CF4}"
        SBL=">"
    fi

    case "$1" in
    "u")
        printf %s "${CLU}";;
    "h")
        printf %s "${CLH}";;
    *)
        printf %s "${SBL}";;
    esac
}

term_s()
{
    sel_lng
    
    case "$(tty)" in
    *tty*)
        printf %s "${LNG_L}";;

    *pts*)
        printf %s "${LNG_N}";;
        
    *);;
    esac
}

term_n()
{
    tty | sed -e 's/\/dev\///g'
}

term()
{
    sel_lng

    # Split "printf" to multiple lines with symbol "`"
    # Разбиваем "printf" на несколько строк символом "`"
    printf "%s[(${LNG_LNG})${LNG_T_T}: $(term_s) | ${LNG_T_N}: $(term_n) | `
            `$(date +%j)-${LNG_T_D} > $(date +%W)-${LNG_T_W}]" "${CF8}"
}

center()
{
    termwidth="$(tput cols)"
    
    padding="$(printf '%0.1s' '='{1..500})"

    # const - Extra length "=" (varies)
    # const - Добавочная длинна "=" (варьируется)
    local -i const=37
    
    # Split "printf" to multiple lines with symbol "\"
    # Разбиваем "printf" на несколько строк символом "\" 
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth+const-${#1})/2))" \
            "${CF12}$padding" "$1" 0 "$(((termwidth+const+1-${#1})/2 ))" "${CF12}$padding"
}

wd_color()
{
    if [ "$(date +%a)" == ${LNG_D_W} ]
    then
        echo "${CF9}"
    else
        echo "${CF10}"
    fi
}

# If the lines are offset manipulate the digits in the INDENT variable
# Если строки смещены, манипулируйте цифрами в переменной INDENT
host()
{
    sel_lng

    LT="${CF9}[${CF13}${LNG_TSK} → $(jobs | wc -l)${CF9} |`
        ` $(USC "u")${USER}${CF8}@$(USC "h")${HOSTNAME}${CF9}]";

        RT="${CF11}[$(wd_color)$(date +%a)${CF11}. $(date +%d) $(date +%h). $(date +%Y)${LNG_T_Y} |`
        ` $(date +%T)]";

    printf "${CTC}%*s\r%s" "${INDENT}" "${RT}" "${LT}"
}

# Command Check Status & Compile Prompt
extstat() 
{
    # Return the result of the last executed command
    # Вернуть результат последней выполненной команды
    BC=$?

    # Checking
    # Проверка
    if [ ${BC} -eq 0 ]
    then
        CHK_I="${CF2}[✔]${CF15}"
        CHK_A="${CF2}▶$(USC "u")"
        ERR_C="${CTC}${CTB}"
    else
        CHK_I="${CF1}[✘(${BC})]${CF15}"
        CHK_A="${CF1}▶$(USC "u")"
        ERR_C="${CB1}${CTB}"
    fi
    
    # Split "echo" to multiple lines with symbol "`"
    # Разбиваем "echo" на несколько строк символом "`"
    echo -e "${ERR_C}$(center "$(term)")\n$(host)\n${CF6}[$(pwd)]\n`
            `${CHK_I}[$(history | grep -cw "")]~$(USC "s"):${CHK_A}"
}
# Prompt
# "\" - Escaping non-printable characters
# "\" - Экранирование непечатаемых символов
PS1="\$(extstat) "

# Get Self IP
# Получить свой IP
#PS1='$(ip route get 1.1.1.1 | awk -F"src " '"'"'NR==1{split($2,a," ");print a[1]}'"'"')'

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
#"date +\%D::\%m:\%S"
