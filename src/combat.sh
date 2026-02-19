iniciar_fase() {
    vida=$vida_max
    cooldown=0
    pocao_usada=false

    if (( fase % 5 == 0 )); then
        inimigo=$(( 120 + nivel * 20 ))
        centralizar "${MAGENTA}⚠ CHEFÃO DA FASE $fase ⚠${NC}"
    else
        inimigo=$(( 60 + nivel * 15 ))
    fi

    inimigo_max=$inimigo

    echo ""
    centralizar "================================="
    centralizar "${CYAN}FASE $fase | NÍVEL $nivel${NC}"
    centralizar "================================="
}

mostrar_status() {
    echo ""

    barra_jogador=$(barra_vida $vida $vida_max)
    barra_inimigo=$(barra_vida $inimigo $inimigo_max)

    centralizar "Vida: ${GREEN}$vida${NC}  $barra_jogador"
    centralizar "Inimigo: ${RED}$inimigo${NC}  $barra_inimigo"
    centralizar "XP: ${YELLOW}$xp / $xp_proximo${NC}"
    centralizar "Cooldown Sobrecarga: $cooldown"

    if [ "$pocao_usada" = false ]; then
        centralizar "Poção disponível: ${GREEN}Sim${NC}"
    else
        centralizar "Poção disponível: ${RED}Não${NC}"
    fi

    echo ""
    centralizar "1 - Atacar"
    centralizar "2 - Defender"
    centralizar "3 - Sobrecarga"
    centralizar "4 - Usar Poção"
    centralizar "5 - Sair"
    echo ""
}

turno_jogador() {
    read escolha

    case $escolha in
        1) # Atacar
            dano=$(( RANDOM % (18 + nivel) + 5 ))
            inimigo=$(( inimigo - dano ))
            ;;
        2) # Defender
            dano_inimigo=$(( RANDOM % (15 + nivel) + 5 ))
            dano_inimigo=$(( dano_inimigo / 2 ))
            vida=$(( vida - dano_inimigo ))
            if [ $cooldown -gt 0 ]; then
                cooldown=$(( cooldown - 1 ))
            fi
            return
            ;;
        3) # Sobrecarga
            if [ $cooldown -le 0 ]; then
                dano=$(( RANDOM % 30 + 25 ))
                inimigo=$(( inimigo - dano ))
                cooldown=3
            fi
            ;;
        4) # Poção
            if [ "$pocao_usada" = false ]; then
                vida=$vida_max
                pocao_usada=true
            fi
            ;;
        5)
            exit
            ;;
        *)
            return
            ;;
    esac

    # Turno do inimigo
    dano_inimigo=$(( RANDOM % (15 + nivel) + 5 ))
    vida=$(( vida - dano_inimigo ))

    if [ $cooldown -gt 0 ]; then
        cooldown=$(( cooldown - 1 ))
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

            if [ $vida -le 0 ]; then
                centralizar "${RED}Você morreu.${NC}"
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
                    centralizar "${CYAN}LEVEL UP! Agora nível $nivel${NC}"
                fi
            fi
        done
    done
}

