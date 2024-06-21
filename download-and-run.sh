#!/bin/bash

# Define a URL do script principal
SCRIPT_URL="https://raw.githubusercontent.com/rafaeloliveiraz/WP-Plugin-Starter/main/create-plugin.sh"

# Define o diretório onde o script será baixado e executado
REPO_DIR="wp-plugin-starter"
SCRIPT_PATH="$REPO_DIR/create-plugin.sh"

# Verifica se o diretório do repositório já existe
if [ -d "$REPO_DIR" ]; then
  echo "O diretório $REPO_DIR já existe. Removendo..."
  rm -rf $REPO_DIR
fi

# Crie o diretório do repositório novamente
mkdir -p $REPO_DIR

# Baixe o script principal para o diretório do repositório
curl -s -o $SCRIPT_PATH $SCRIPT_URL

# Dê permissão de execução ao script baixado
chmod +x $SCRIPT_PATH

# Execute o script principal
./$SCRIPT_PATH

# Remova o script após a execução (opcional)
# rm -f $SCRIPT_PATH
