# ===== CORES =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ===== CENTRALIZAR =====
centralizar() {
    largura_terminal=$(tput cols)
    texto="$1"
    texto_limpo=$(echo -e "$texto" | sed 's/\x1b\[[0-9;]*m//g')
    comprimento=${#texto_limpo}

    if [ "$comprimento" -lt "$largura_terminal" ]; then
        padding=$(( (largura_terminal - comprimento) / 2 ))
        printf "%*s" "$padding" ""
    fi

    echo -e "$texto"
}

# ===== BARRA DE VIDA =====
barra_vida() {
    atual=$1
    maximo=$2
    largura_barra=20

    if [ -z "$atual" ]; then atual=0; fi
    if [ -z "$maximo" ] || [ "$maximo" -le 0 ]; then maximo=1; fi

    proporcao=$(( atual * largura_barra / maximo ))

    if [ "$proporcao" -lt 0 ]; then proporcao=0; fi
    if [ "$proporcao" -gt "$largura_barra" ]; then 
proporcao=$largura_barra; fi

    vazia=$(( largura_barra - proporcao ))

    barra_cheia=$(printf "%${proporcao}s" | tr ' ' '█')
    barra_vazia=$(printf "%${vazia}s" | tr ' ' '░')

    echo "${barra_cheia}${barra_vazia}"
}

