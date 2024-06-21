#!/bin/bash

# Defina a URL do script principal
SCRIPT_URL="https://raw.githubusercontent.com/rafaeloliveiraz/WP-Plugin-Starter/main/create-plugin.sh"

# Defina o diretório onde o script será baixado e executado
REPO_DIR="wp-plugin-starter"
SCRIPT_PATH="$REPO_DIR/create-plugin.sh"

# Crie o diretório do repositório se ele não existir
mkdir -p $REPO_DIR

# Baixe o script principal para o diretório do repositório
curl -s $SCRIPT_URL -o $SCRIPT_PATH

# Dê permissão de execução ao script baixado
chmod +x $SCRIPT_PATH

# Navegue até o diretório do repositório
cd $REPO_DIR

# Execute o script principal
$SCRIPT_PATH

# Remova o script após a execução
rm -f $SCRIPT_PATH

# Navegue de volta ao diretório original
cd ..
