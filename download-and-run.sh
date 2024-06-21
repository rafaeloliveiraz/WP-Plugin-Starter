#!/bin/bash

# Defina a URL do script principal
SCRIPT_URL="https://raw.githubusercontent.com/rafaeloliveiraz/WP-Plugin-Starter/main/create-plugin.sh"

# Baixe o script principal para um diretório temporário
TEMP_SCRIPT=$(mktemp)
curl -s $SCRIPT_URL -o $TEMP_SCRIPT

# Dê permissão de execução ao script baixado
chmod +x $TEMP_SCRIPT

# Execute o script principal
$TEMP_SCRIPT

# Remova o script temporário
rm -f $TEMP_SCRIPT
