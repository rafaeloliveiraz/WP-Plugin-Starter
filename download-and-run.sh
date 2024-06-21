#!/bin/bash

# Defina a URL do script principal
SCRIPT_URL="https://raw.githubusercontent.com/rafaeloliveiraz/WP-Plugin-Starter/main/create-plugin.sh"

# Crie um diretório temporário para executar o script
TEMP_DIR=$(mktemp -d)
TEMP_SCRIPT="$TEMP_DIR/create-plugin.sh"

# Baixe o script principal para o diretório temporário
curl -s $SCRIPT_URL -o $TEMP_SCRIPT

# Dê permissão de execução ao script baixado
chmod +x $TEMP_SCRIPT

# Navegue até o diretório temporário
cd $TEMP_DIR

# Execute o script principal
$TEMP_SCRIPT

# Remova o diretório temporário após a execução
cd -
rm -rf $TEMP_DIR
