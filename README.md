# Aplicação do Paradigma LangSec na Segurança de Sistemas Ciberfísicos: Prevenção de Injeções no Nível do Parser

Este repositório contém uma implementação desenvolvida como prova de conceito dos temas abordados no artigo Aplicação do Paradigma LangSec na Segurança de Sistemas Ciberfísicos: Prevenção de Injeções no Nível do Parser. O código foi elaborado como requisito da disciplina Teoria da Computação, do Programa de Pós-Graduação em Computação (PPCOMP), referente ao período letivo 2026/1, com o objetivo de demonstrar, de forma prática, os conceitos discutidos no trabalho.

---

## Arquitetura

O código está dividido de forma modular:

### 1. Domínio (`Domain/`)
- **`Grammar.hs`:** Define o alfabeto seguro.
- **`Internal.hs` e `Types.hs`:** Implementam o encapsulamento seguro dos dados através de `newtype` (padrão *Smart Constructors* / Tipagem Forte).
- **`Parser.hs`:** Analisa a string de forma linear para garantir o comprimento mínimo/máximo e a veracidade de cada caractere individual.

### 2. Automatos (`Automata/`)
- **`DFA.hs`:** Implementação de um Automato Finito Determinístico. Ele modela formalmente o conjunto de estados ($Q$), o estado inicial ($q_0$), os estados de aceitação ($F$) e a função de transição ($\delta : Q \times \Sigma \rightarrow Q$).

### 3. Pipeline Principal (`app/`)
- **`Main.hs`:** Realiza o parse inicial e executa uma dupla verificação paralela através dos DFAs gerados dinamicamente para o SSID e para a Palavra-passe. Contém também testes simulados com casos válidos e inválidos.

---

## Como Executar

É necessário ter o **Nix** instalado (instruções em [nixos.org](https://nixos.org/)).

1. **Entrar no shell do Nix:**
Execute o comando abaixo para baixar e isolar todas as dependências do projeto (incluindo o compilador GHC compatível):
```bash
nix-shell
```

1. **Executar:**
Dentro do ambiente do `nix-shell`, execute o arquivo principal com o `runghc`:
```bash
runghc -isrc app/Main.hs
```


4. **Compilar via Cabal (Opcional):**
Se preferir compilar o executável de forma tradicional:
```bash
cabal build
cabal run
```

---

## 📁 Estrutura de Diretórios

```text
.
├── app/
│   └── Main.hs                     
├── src/
│   ├── Automata/
│   │   └── DFA.hs                  # Automato Finito Determinístico
│   └── Domain/
│       ├── Grammar.hs              # Alfabeto e definições de restrições
│       ├── Internal.hs             # Representação interna dos tipos de dados
│       ├── Parser.hs               
│       └── Types.hs                
├── CHANGELOG.md                   
├── shell.nix                       
└── tc-artigo-implement.cabal     

```
