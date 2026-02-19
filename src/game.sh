#!/bin/bash

# ===== CORES =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

SAVE_FILE="save.dat"

# ===== ESTADO =====
nivel=1
fase=1
vida_max=100
xp=0
xp_proximo=50
defendendo=false
cooldown=0
pocao_usada=false
inimigo_stunado=false

# ===== FUNÇÃO PARA CENTRALIZAR TEXTO =====
centralizar() {
    largura_terminal=$(tput cols)
    texto="$1"
    comprimento=${#texto}
    if [ $comprimento -lt $largura_terminal ]; then
        padding=$(( (largura_terminal - comprimento) / 2 ))
        printf "%*s%s\n" $padding "" "$texto"
    else
        echo "$texto"
    fi
}

# ===== ANIMAÇÃO =====
animar_texto() {
    texto="$1"
    largura_terminal=$(tput cols)
    comprimento=${#texto}
    padding=$(( (largura_terminal - comprimento) / 2 ))
    printf "%*s" $padding ""
    for (( i=0; i<${#texto}; i++ )); do
        printf "${texto:$i:1}"
        sleep 0.015
    done
    echo ""
}

# ===== TELA DE TÍTULO =====
tela_titulo() {
    clear
    echo -e "${CYAN}"

    largura=$(tput cols)

    if [ "$largura" -ge 80 ]; then
        centralizar "  _____  _____  _____  _____ "
        centralizar " |_   _||  ___||  ___||  ___|"
        centralizar "   | |  | |__  | |__  | |__  "
        centralizar "   | |  |  __| |  __| |  __| "
        centralizar "   | |  | |___ | |___ | |___ "
        centralizar "   \_/   \____/ \____/ \____/ "
        echo ""
        centralizar "SPACE ARENA"
    else
        centralizar "TERMINAL SPACE ARENA"
    fi

    echo -e "${NC}"
    sleep 0.4

    animar_texto "Inicializando sistemas..."
    sleep 0.3
    animar_texto "Carregando motores..."
    sleep 0.3
    animar_texto "Preparando combate..."
    sleep 0.6

    echo ""
    centralizar "Pressione ENTER para continuar"
    read
}

# ===== SAVE =====
salvar_progresso() {
    echo "nivel=$nivel" > "$SAVE_FILE"
    echo "fase=$fase" >> "$SAVE_FILE"
    echo "vida_max=$vida_max" >> "$SAVE_FILE"
    echo "xp=$xp" >> "$SAVE_FILE"
    echo "xp_proximo=$xp_proximo" >> "$SAVE_FILE"
    echo -e "${GREEN}Progresso salvo.${NC}"
}

carregar_progresso() {
    if [ -f "$SAVE_FILE" ]; then
        source "$SAVE_FILE"
        echo -e "${CYAN}Progresso carregado.${NC}"
        sleep 1
    else
        echo "Nenhum progresso encontrado."
        sleep 1
    fi
}

resetar_progresso() {
    rm -f "$SAVE_FILE"
    echo -e "${RED}Progresso apagado.${NC}"
    sleep 1
}

# ===== MENU =====
menu_inicial() {
    clear
    centralizar "================================="
    centralizar "TERMINAL SPACE ARENA"
    centralizar "================================="
    echo ""
    centralizar "1 - Novo Jogo"
    centralizar "2 - Continuar"
    centralizar "3 - Resetar Progresso"
    centralizar "4 - Sair"
    echo ""
    read opcao

    case $opcao in
        1)
            nivel=1
            fase=1
            vida_max=100
            xp=0
            xp_proximo=50
            jogo_loop
            ;;
        2)
            carregar_progresso
            jogo_loop
            ;;
        3)
            resetar_progresso
            menu_inicial
            ;;
        4)
            exit
            ;;
        *)
            menu_inicial
            ;;
    esac
}

# ===== JOGO =====
iniciar_fase() {
    vida=$vida_max
    cooldown=0
    pocao_usada=false
    inimigo_stunado=false

    if (( fase % 5 == 0 )); then
        inimigo=$(( 120 + nivel * 20 ))
        boss=true
        echo -e "${MAGENTA}⚠ CHEFÃO DA FASE $fase ⚠${NC}"
    else
        inimigo=$(( 60 + nivel * 15 ))
        boss=false
    fi

    echo ""
    centralizar "================================="
    centralizar "FASE $fase | NÍVEL $nivel"
    centralizar "================================="
}

mostrar_status() {
    echo ""
    centralizar "Vida: $vida"
    centralizar "Inimigo: $inimigo"
    centralizar "XP: $xp / $xp_proximo"
    centralizar "Cooldown: $cooldown"

    if [ "$pocao_usada" = false ]; then
        centralizar "Poção disponível: Sim"
    else
        centralizar "Poção disponível: Não"
    fi
    echo ""
}

turno_jogador() {
    centralizar "1 - Atacar"
    centralizar "2 - Defender"
    centralizar "3 - Sobrecarga"
    centralizar "4 - Usar Poção"
    centralizar "5 - Salvar e Sair"
    read escolha

    defendendo=false

    case $escolha in
        1)
            dano=$(( RANDOM % (18 + nivel) + 5 ))
            inimigo=$(( inimigo - dano ))
            ;;
        2)
            defendendo=true
            ;;
        3)
            if [ $cooldown -le 0 ]; then
                dano=$(( RANDOM % 30 + 25 ))
                inimigo=$(( inimigo - dano ))
                cooldown=3
                if [ $(( RANDOM % 2 )) -eq 0 ]; then
                    inimigo_stunado=true
                fi
            fi
            ;;
        4)
            if [ "$pocao_usada" = false ]; then
                vida=$vida_max
                pocao_usada=true
            fi
            ;;
        5)
            salvar_progresso
            exit
            ;;
    esac
}

turno_inimigo() {
    if [ "$inimigo_stunado" = true ]; then
        inimigo_stunado=false
        return
    fi

    ataque=$(( RANDOM % (15 + nivel) + 5 ))

    if [ "$defendendo" = true ]; then
        ataque=$(( ataque / 2 ))
    fi

    vida=$(( vida - ataque ))

    if [ $cooldown -gt 0 ]; then
        cooldown=$(( cooldown - 1 ))
    fi
}

verificar_estado() {
    if [ $vida -le 0 ]; then
        centralizar "Você morreu na fase $fase."
        echo ""
        centralizar "Deseja salvar antes de sair? (s/n)"
        read resp
        if [ "$resp" = "s" ]; then
            salvar_progresso
        fi
        exit
    fi

    if [ $inimigo -le 0 ]; then
        xp=$(( xp + 20 ))
        fase=$(( fase + 1 ))

        if [ $xp -ge $xp_proximo ]; then
            xp=$(( xp - xp_proximo ))
            xp_proximo=$(( xp_proximo + 30 ))
            nivel=$(( nivel + 1 ))
            vida_max=$(( vida_max + 15 ))
        fi
    fi
}

jogo_loop() {
    while true
    do
        iniciar_fase
        while [ $vida -gt 0 ] && [ $inimigo -gt 0 ]
        do
            mostrar_status
            turno_jogador
            turno_inimigo
            verificar_estado
        done
    done
}

# ===== START =====
tela_titulo
menu_inicial

