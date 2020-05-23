function rnd {
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${1:-13}
}

function gen-ssh-key {
    local file='id_ed25519'
    local comment=$(date -Iseconds)
    local options=$(getopt -o c:f: -- "$@")
    eval set -- "$options"
    while true; do
        case "$1" in
        -c )
            shift
            comment="$1"
            ;;
        -f )
            shift
            file="$1"
            ;;
        -- )
            shift
            break
            ;;
        esac
        shift
    done
    ssh-keygen -t ed25519 -f ${file} -C ${comment}
    if (( $+commands[puttygen] )); then
        puttygen ${file} -o ${file}.ppk
    fi
}

alias ssh-copy-id-with-pwd='ssh-copy-id -o PreferredAuthentications=password -o PubkeyAuthentication=no -f -i'

function gen-self-signed-cert {
    openssl req \
        -newkey rsa:4096 -nodes -sha256 -keyout $1.key \
        -x509 -days 365 -out $1.crt \
        -subj /CN=$1
}

function gen-wg-key {
    umask 077 # default: 022
    wg genkey | tee ${1:-wg} | wg pubkey > ${1:-wg}.pub
}

export PASSWORD_RULE_PATH=$HOME/.config/passwd
if [ -d $PASSWORD_RULE_PATH ]; then
    chmod -R go-rwx $PASSWORD_RULE_PATH
fi

function gpw {
    local length=12
    local config='default'
    local options=$(getopt -o c:l: -- "$@")
    eval set -- "$options"
    while true; do
        case "$1" in
        -c)
            shift
            config="$1"
            ;;
        -l)
            shift
            length="$1"
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done
    # local pwd=$(eval "echo \"\$$config\"")
    pwd=$(cat $PASSWORD_RULE_PATH/token/$config)
    pwgen -B1cn ${length} -H <(echo -n "$1" | openssl dgst -sha1 -hmac "$pwd")
}

function _comp_gpw {
    local name
    _arguments '-c[config]:config:->config' '-l[length]:length:' "1:item:->item"
    case "$state" in
        config)
            _alternative ":config:($(ls -A $PASSWORD_RULE_PATH/rule))"
        ;;
        item)
            if [ -z ${opt_args[-c]} ]; then
                name="default"
            else
                name=${opt_args[-c]}
            fi
            local matcher
            _alternative "::($(cat $PASSWORD_RULE_PATH/rule/$name))"
        ;;
    esac
}

compdef _comp_gpw gpw