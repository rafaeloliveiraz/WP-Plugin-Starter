#!/bin/bash

echo "Iniciando script download-and-run.sh"

# Define a URL do script principal
SCRIPT_URL="https://raw.githubusercontent.com/rafaeloliveiraz/WP-Plugin-Starter/main/create-plugin.sh"

# Define o diretório onde o script será baixado e executado
REPO_DIR="wp-plugin-starter"
SCRIPT_PATH="$REPO_DIR/create-plugin.sh"

echo "Verificando se o diretório $REPO_DIR já existe..."
# Verifica se o diretório do repositório já existe
if [ -d "$REPO_DIR" ]; then
  echo "O diretório $REPO_DIR já existe. Removendo..."
  rm -rf $REPO_DIR
fi

echo "Criando o diretório $REPO_DIR..."
# Crie o diretório do repositório novamente
mkdir -p $REPO_DIR

echo "Baixando o script principal $SCRIPT_URL para $SCRIPT_PATH..."
# Baixe o script principal para o diretório do repositório
curl -s -o $SCRIPT_PATH $SCRIPT_URL

echo "Dando permissão de execução ao script baixado $SCRIPT_PATH..."
# Dê permissão de execução ao script baixado
chmod +x $SCRIPT_PATH

echo "Executando o script principal $SCRIPT_PATH..."
# Execute o script principal
./$SCRIPT_PATH

# Remova o script após a execução (opcional)
# rm -f $SCRIPT_PATH

echo "Script download-and-run.sh concluído"
