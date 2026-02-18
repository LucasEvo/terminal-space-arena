#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

nivel=1
vida_max=100

while true
do
    vida=$vida_max

    if (( nivel % 5 == 0 )); then
        inimigo=$(( 120 + nivel * 20 ))
        boss=true
        echo -e "${MAGENTA}⚠ CHEFÃO DETECTADO ⚠${NC}"
    else
        inimigo=$(( 60 + nivel * 15 ))
        boss=false
    fi

    echo ""
    echo "================================="
    echo -e "      ${CYAN}BATALHA ESPACIAL - NÍVEL $nivel${NC}"
    echo "================================="

    while [ $vida -gt 0 ] && [ $inimigo -gt 0 ]
    do
        echo ""
        echo -e "Sua vida: ${GREEN}$vida${NC}"
        echo -e "Vida do inimigo: ${RED}$inimigo${NC}"
        echo ""
        echo "1 - Atacar"
        echo "2 - Defender"
        read escolha

        if [ "$escolha" = "1" ]; then
            critico=$(( RANDOM % 5 ))
            dano=$(( RANDOM % (18 + nivel) + 5 ))

            if [ $critico -eq 0 ]; then
                dano=$(( dano * 2 ))
                echo -e "${YELLOW}🔥 ATAQUE CRÍTICO!${NC}"
            fi

            inimigo=$(( inimigo - dano ))
            echo "Você causou $dano de dano!"

        elif [ "$escolha" = "2" ]; then
            echo "🛡 Você entrou em modo defensivo!"
        else
            echo "Você hesitou..."
        fi

        if [ "$boss" = true ]; then
            crit_boss=$(( RANDOM % 3 ))
            ataque_inimigo=$(( RANDOM % (20 + nivel) + 10 ))

            if [ $crit_boss -eq 0 ]; then
                ataque_inimigo=$(( ataque_inimigo * 2 ))
                echo -e "${MAGENTA}💀 CRÍTICO DO CHEFÃO!${NC}"
            fi
        else
            ataque_inimigo=$(( RANDOM % (12 + nivel) + 5 ))
        fi

        if [ "$escolha" = "2" ]; then
            ataque_inimigo=$(( ataque_inimigo / 2 ))
            echo "🛡 Defesa reduziu o dano!"
        fi

        vida=$(( vida - ataque_inimigo ))
        echo "O inimigo causou $ataque_inimigo de dano!"
    done

    echo ""
    if [ $vida -gt 0 ]; then
        echo -e "${GREEN}Você venceu o nível $nivel!${NC}"
        nivel=$(( nivel + 1 ))
        vida_max=$(( vida_max + 10 ))
        sleep 2
    else
        echo -e "${RED}Você morreu no nível $nivel...${NC}"
        break
    fi
done

echo ""
echo "Fim da missão."

