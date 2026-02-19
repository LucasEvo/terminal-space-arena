tela_titulo() {
    clear
    echo -e "${CYAN}"
    centralizar "  _____  _____  _____  _____ "
    centralizar " |_   _||  ___||  ___||  ___|"
    centralizar "   | |  | |__  | |__  | |__  "
    centralizar "   | |  |  __| |  __| |  __| "
    centralizar "   | |  | |___ | |___ | |___ "
    centralizar "   \_/   \____/ \____/ \____/ "
    echo ""
    centralizar "${YELLOW}SPACE ARENA${NC}"
    echo -e "${NC}"
    sleep 0.4
    centralizar "Pressione ENTER para continuar"
    read
}

menu_inicial() {
    clear
    centralizar "================================="
    centralizar "${CYAN}TERMINAL SPACE ARENA${NC}"
    centralizar "================================="
    echo ""
    centralizar "1 - Novo Jogo"
    centralizar "2 - Continuar"
    centralizar "3 - Resetar Progresso"
    centralizar "4 - Sair"
    echo ""
    read opcao

    case $opcao in
        1) jogo_loop ;;
        2) carregar_progresso; jogo_loop ;;
        3) rm -f ../save.dat; menu_inicial ;;
        4) exit ;;
        *) menu_inicial ;;
    esac
}

