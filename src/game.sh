#!/bin/bash

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
inimigo_stunado=false

# ===== FUNÇÕES DE SAVE =====

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
    echo "================================="
    echo -e "${CYAN}   TERMINAL SPACE ARENA${NC}"
    echo "================================="
    echo "1 - Novo Jogo"
    echo "2 - Continuar"
    echo "3 - Resetar Progresso"
    echo "4 - Sair"
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
    echo "================================="
    echo -e "FASE $fase | NÍVEL $nivel"
    echo "================================="
}

mostrar_status() {
    echo ""
    echo "Vida: $vida"
    echo "Inimigo: $inimigo"
    echo "XP: $xp / $xp_proximo"
    echo "Cooldown Sobrecarga: $cooldown"
    echo ""
}

turno_jogador() {
    echo "1 - Atacar"
    echo "2 - Defender"
    echo "3 - Sobrecarga"
    echo "4 - Salvar e Sair"
    read escolha

    defendendo=false

    case $escolha in
        1)
            dano=$(( RANDOM % (18 + nivel) + 5 ))
            inimigo=$(( inimigo - dano ))
            echo "Você causou $dano."
            ;;
        2)
            defendendo=true
            echo "Modo defensivo ativado."
            ;;
        3)
            if [ $cooldown -le 0 ]; then
                dano=$(( RANDOM % 30 + 25 ))
                inimigo=$(( inimigo - dano ))
                cooldown=3
                echo "Sobrecarga causou $dano!"
                chance=$(( RANDOM % 2 ))
                if [ $chance -eq 0 ]; then
                    inimigo_stunado=true
                    echo "Inimigo atordoado!"
                fi
            else
                echo "Em recarga."
            fi
            ;;
        4)
            salvar_progresso
            exit
            ;;
    esac
}

turno_inimigo() {

    if [ "$inimigo_stunado" = true ]; then
        echo "Inimigo perdeu o turno."
        inimigo_stunado=false
        return
    fi

    ataque=$(( RANDOM % (15 + nivel) + 5 ))

    if [ "$defendendo" = true ]; then
        ataque=$(( ataque / 2 ))
    fi

    vida=$(( vida - ataque ))
    echo "Inimigo causou $ataque."

    if [ $cooldown -gt 0 ]; then
        cooldown=$(( cooldown - 1 ))
    fi
}

verificar_estado() {
    if [ $vida -le 0 ]; then
        echo -e "${RED}Você morreu na fase $fase.${NC}"
        echo "Deseja salvar antes de sair? (s/n)"
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
            echo "LEVEL UP! Agora nível $nivel"
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
menu_inicial

