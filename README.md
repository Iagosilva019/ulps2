# PS2 ISO to UL Converter (Bash Tool)
Está é uma ferramenta de linha de comando desenvolvida em Bash para sistemas Ubuntu/Linux, projetada para converter imagens de jogos de Playstation 2 (formanto .iso) para o formato fragmentado UL (utilizado pelo Open PS2 Loader- OPL).

Está ferramenta é ideal para usuários que precisam transferir jogos para dispositivos formatados em FAT32, superando limite de 4GB por arquivo do sistema de arquivos.

# Principais Funcinalidades
- Conversão automatizada:  Transforma arquivos .iso em múltiplos arquivos .ul compativeis com o padrão USB Advance/Extreme
- Compatibilidade com OPL: Gera arquivos prontos para serem lidos pelo Open PS2 Loader via USB.
- Leve e Rápida: Execução nativa no terminal, sem necessidade de interfaces gráficas pesadas.

# Como Funciona a Estrutura UL
Quando um jogo de PS2 é convertido para formato UL, ele é dividido em partes menores (geralmente de 1GB) e renomeado seguindo um padrão especifico que o console consegue identificar.

# Pré-requisitos

# Instalando e executando a ferramenta:

```git clone https://github.com/Iagosilva019/ulps2```

- coloque o arquivo ISO(jogo) na mesma pasta da ferramenta


```cd ulps2```

```bash ulps2.sh```
