# 🚀 Terminal Space Arena

Um jogo de combate por turnos totalmente executado no terminal, 
desenvolvido em Bash, com arquitetura modular e sistema de progressão.

Projeto criado com foco em organização de código, separação de 
responsabilidades, compatibilidade com Bash 3.2 (macOS) e evolução 
incremental versionada com Git.

---

## 🎮 Sobre o Jogo

Terminal Space Arena é um jogo de combate em turnos onde o jogador 
enfrenta inimigos progressivamente mais fortes, incluindo chefões a cada 5 
fases.

O jogo inclui:

- Sistema de níveis  
- Progressão de XP  
- Barra de vida dinâmica no terminal  
- Habilidade especial com cooldown  
- Poção limitada por fase  
- Sistema de salvamento  
- Interface centralizada responsiva  
- Arquitetura modular  

Tudo executado exclusivamente em Bash.

---

## 🧠 Conceitos Técnicos Aplicados

Este projeto vai além de um simples jogo. Ele demonstra:

- Modularização com `source`
- Separação de responsabilidades (UI, combate, utilidades, persistência)
- Funções reutilizáveis
- Controle de estado global
- Programação defensiva (evitando divisão por zero)
- Compatibilidade com versões antigas do Bash
- Estrutura escalável
- Versionamento incremental documentado

---

## 📂 Estrutura do Projeto

terminal-space-arena/
│
├── src/
│   ├── main.sh        # Ponto de entrada da aplicação
│   ├── ui.sh          # Interface e menus
│   ├── combat.sh      # Mecânicas de combate
│   ├── save.sh        # Sistema de salvamento
│   └── utils.sh       # Funções utilitárias (cores, centralização, 
barra)
│
├── save.dat           # Arquivo de progresso
└── README.md

---

## ▶️ Como Executar

No terminal:

cd terminal-space-arena/src  
chmod +x main.sh  
./main.sh  

Compatível com:

- macOS (Bash 3.2)
- Linux

---

## 🛠 Tecnologias Utilizadas

- Bash  
- ANSI Escape Codes  
- Git  
- Terminal nativo  

---

## 🧱 Decisões de Arquitetura

O projeto começou como um único script monolítico e foi posteriormente 
refatorado para arquitetura modular, visando:

- Melhor legibilidade  
- Manutenção simplificada  
- Escalabilidade  
- Clareza estrutural  

A refatoração foi versionada e documentada no histórico de commits.

---

## 🚧 Roadmap Futuro

- Sistema de habilidades desbloqueáveis  
- Barra de XP visual  
- Inimigos com comportamentos diferenciados  
- Sistema de itens  
- Separação adicional entre lógica de progressão e combate  
- Melhorias visuais na interface  

---

## 📌 Objetivo do Projeto

Demonstrar domínio de:

- Lógica de programação  
- Organização modular  
- Evolução incremental de software  
- Controle de estado em shell script  
- Pensamento arquitetural aplicado mesmo em ambientes simples  

Projeto desenvolvido como exercício prático de evolução técnica e 
organização de código.

