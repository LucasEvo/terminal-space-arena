#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

nivel=1
fase=1
vida_max=100
xp=0
xp_proximo=50
defendendo=false
cooldown=0
pocao_usada=false
inimigo_stunado=false

iniciar_nivel() {
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
    echo "================================="
    echo -e "   ${CYAN}FASE $fase  |  NÍVEL $nivel${NC}"
    echo "================================="
}

mostrar_status() {
    echo ""
    echo -e "Sua vida: ${GREEN}$vida${NC}"
    echo -e "Vida do inimigo: ${RED}$inimigo${NC}"
    echo -e "XP: ${YELLOW}$xp / $xp_proximo${NC}"
    echo -e "Cooldown da Sobrecarga: $cooldown turnos"

    if [ "$pocao_usada" = false ]; then
        echo -e "Poção disponível: ${GREEN}Sim${NC}"
    else
        echo -e "Poção disponível: ${RED}Não${NC}"
    fi

    echo ""
}

turno_jogador() {
    echo "1 - Atacar"
    echo "2 - Defender"
    echo "3 - Sobrecarga"
    echo "4 - Usar Poção"
    read escolha

    defendendo=false

    case $escolha in
        1)
            critico=$(( RANDOM % 5 ))
            dano=$(( RANDOM % (18 + nivel) + 5 ))

            if [ $critico -eq 0 ]; then
                dano=$(( dano * 2 ))
                echo -e "${YELLOW}🔥 ATAQUE CRÍTICO!${NC}"
            fi

            inimigo=$(( inimigo - dano ))
            echo "Você causou $dano de dano!"
            ;;
        2)
            defendendo=true
            echo "🛡 Você entrou em modo defensivo!"
            ;;
        3)
            if [ $cooldown -le 0 ]; then
                dano=$(( RANDOM % 30 + 25 ))
                inimigo=$(( inimigo - dano ))
                cooldown=3
                echo -e "${CYAN}⚡ SOBRECARGA ATIVADA! $dano de 
dano!${NC}"

                chance_stun=$(( RANDOM % 2 ))
                if [ $chance_stun -eq 0 ]; then
                    inimigo_stunado=true
                    echo -e "${CYAN}⚡ O inimigo ficou ATORDOADO!${NC}"
                fi
            else
                echo "Habilidade ainda em recarga!"
            fi
            ;;
        4)
            if [ "$pocao_usada" = false ]; then
                vida=$vida_max
                pocao_usada=true
                echo -e "${GREEN}🧪 Poção usada! Vida restaurada 
totalmente!${NC}"
            else
                echo "Você já usou a poção nesta fase!"
            fi
            ;;
        *)
            echo "Você hesitou..."
            ;;
    esac
}

turno_inimigo() {

    if [ "$inimigo_stunado" = true ]; then
        echo -e "${CYAN}O inimigo perdeu o turno!${NC}"
        inimigo_stunado=false
        return
    fi

    if [ "$boss" = true ]; then
        crit_boss=$(( RANDOM % 3 ))
        ataque=$(( RANDOM % (20 + nivel) + 10 ))

        if [ $crit_boss -eq 0 ]; then
            ataque=$(( ataque * 2 ))
            echo -e "${MAGENTA}💀 CRÍTICO DO CHEFÃO!${NC}"
        fi
    else
        ataque=$(( RANDOM % (12 + nivel) + 5 ))
    fi

    if [ "$defendendo" = true ]; then
        if [ "$boss" = true ]; then
            ataque=$(( ataque * 40 / 100 ))
            echo "🛡 Defesa absorveu grande parte do dano do chefão!"
        else
            ataque=$(( ataque / 2 ))
            echo "🛡 Defesa reduziu o dano!"
        fi
    fi

    vida=$(( vida - ataque ))
    echo "O inimigo causou $ataque de dano!"

    if [ $cooldown -gt 0 ]; then
        cooldown=$(( cooldown - 1 ))
    fi
}

verificar_vitoria() {
    if [ $vida -le 0 ]; then
        echo -e "${RED}Você morreu na fase $fase...${NC}"
        exit
    fi

    if [ $inimigo -le 0 ]; then
        ganho_xp=$(( 20 + nivel * 5 ))
        xp=$(( xp + ganho_xp ))
        fase=$(( fase + 1 ))

        echo -e "${GREEN}Você venceu a fase!${NC}"
        echo -e "Você ganhou ${YELLOW}$ganho_xp XP${NC}"

        if [ $xp -ge $xp_proximo ]; then
            xp=$(( xp - xp_proximo ))
            xp_proximo=$(( xp_proximo + 30 ))
            nivel=$(( nivel + 1 ))
            vida_max=$(( vida_max + 15 ))
            vida=$vida_max

            echo -e "${CYAN}LEVEL UP! Você agora está no nível 
$nivel${NC}"
        fi

        sleep 2
    fi
}

while true
do
    iniciar_nivel

    while [ $vida -gt 0 ] && [ $inimigo -gt 0 ]
    do
        mostrar_status
        turno_jogador
        turno_inimigo
        verificar_vitoria
    done
done

