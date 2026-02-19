SAVE_FILE="../save.dat"

salvar_progresso() {
    echo "nivel=$nivel" > "$SAVE_FILE"
    echo "fase=$fase" >> "$SAVE_FILE"
    echo "vida_max=$vida_max" >> "$SAVE_FILE"
    echo "xp=$xp" >> "$SAVE_FILE"
    echo "xp_proximo=$xp_proximo" >> "$SAVE_FILE"
    centralizar "${GREEN}Progresso salvo.${NC}"
}

carregar_progresso() {
    if [ -f "$SAVE_FILE" ]; then
        source "$SAVE_FILE"
        centralizar "${CYAN}Progresso carregado.${NC}"
        sleep 1
    fi
}

