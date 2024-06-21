#!/bin/bash

# Define o diretório onde o script será executado
REPO_DIR="$(pwd)"

# Solicita o nome do plugin ao usuário
read -p "Digite o nome do plugin (Ex: Meu Plugin): " PLUGIN_NAME
PLUGIN_DIR="${PLUGIN_NAME// /-}"
PLUGIN_DIR=$(echo "$PLUGIN_DIR" | tr '[:upper:]' '[:lower:]')
PLUGIN_SAFE_NAME=$(echo "$PLUGIN_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
PLUGIN_CLASS_SAFE_NAME=$(echo "$PLUGIN_NAME" | tr ' ' '_')

# Verifica se o diretório do plugin já existe
if [ -d "$REPO_DIR/$PLUGIN_DIR" ]; then
  echo "O diretório $PLUGIN_DIR já existe. Por favor, escolha outro nome."
  exit 1
fi

# Cria o diretório do plugin dentro do diretório definido em $REPO_DIR
mkdir -p "$REPO_DIR/$PLUGIN_DIR/includes"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/admin"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/public"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/assets/css"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/assets/js"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/assets/images"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/languages"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/tests"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/.circleci"
mkdir -p "$REPO_DIR/$PLUGIN_DIR/bin"

# Pergunta informações ao usuário
read -p "Digite o nome do autor: " AUTHOR_NAME
read -p "Digite o site do autor: " AUTHOR_URI
read -p "Digite a versão do plugin (Ex: 1.0): " PLUGIN_VERSION

# Adiciona "(WP Plugin Starter)" ao nome do autor
AUTHOR_NAME="$AUTHOR_NAME (WP Plugin Starter)"

# Função para converter para maiúsculas
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Função para converter para PascalCase
to_pascal_case() {
    echo "$1" | sed -r 's/(^|_)(\w)/\U\2/g'
}

PLUGIN_CONST=$(to_upper "$PLUGIN_SAFE_NAME")
PLUGIN_CLASS=$(to_pascal_case "$PLUGIN_CLASS_SAFE_NAME")

# Cria os arquivos principais do plugin
cat > "$REPO_DIR/$PLUGIN_DIR/${PLUGIN_SAFE_NAME}.php" <<EOL
<?php
/**
 * Plugin Name: ${PLUGIN_NAME}
 * Plugin URI: https://github.com/rafaeloliveiraz/WP-Plugin-Starter
 * Description: Este plugin foi iniciado através da ferramenta WP Plugin Starter desenvolvida por Rafael Oliveira. Veja mais em https://github.com/rafaeloliveiraz/WP-Plugin-Starter
 * Version: ${PLUGIN_VERSION}
 * Author: ${AUTHOR_NAME}
 * Author URI: ${AUTHOR_URI}
 * License: GPL2
 */

if (!defined('WPINC')) {
    die;
}

define('${PLUGIN_CONST}_VERSION', '${PLUGIN_VERSION}');

function activate_${PLUGIN_SAFE_NAME}() {
    require_once plugin_dir_path(__FILE__) . 'includes/class-${PLUGIN_SAFE_NAME}-activator.php';
    ${PLUGIN_CLASS}_Activator::activate();
}
register_activation_hook(__FILE__, 'activate_${PLUGIN_SAFE_NAME}');

function deactivate_${PLUGIN_SAFE_NAME}() {
    require_once plugin_dir_path(__FILE__) . 'includes/class-${PLUGIN_SAFE_NAME}-deactivator.php';
    ${PLUGIN_CLASS}_Deactivator::deactivate();
}
register_deactivation_hook(__FILE__, 'deactivate_${PLUGIN_SAFE_NAME}');

require plugin_dir_path(__FILE__) . 'includes/class-${PLUGIN_SAFE_NAME}.php';

function run_${PLUGIN_SAFE_NAME}() {
    \$plugin = new ${PLUGIN_CLASS}();
    \$plugin->run();
}
run_${PLUGIN_SAFE_NAME}();
EOL

# Cria as classes de ativação, desativação e a classe principal do plugin
cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}-activator.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Activator {
    public static function activate() {
        // Código de ativação aqui.
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}-deactivator.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Deactivator {
    public static function deactivate() {
        // Código de desativação aqui.
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}.php" <<EOL
<?php
class ${PLUGIN_CLASS} {
    public function run() {
        add_action('admin_menu', array(\$this, 'add_plugin_admin_menu'));
    }

    public function add_plugin_admin_menu() {
        add_menu_page(
            '${PLUGIN_NAME}',
            '${PLUGIN_NAME}',
            'manage_options',
            '${PLUGIN_SAFE_NAME}',
            array(\$this, 'display_plugin_admin_page'),
            'dashicons-smiley',
            26
        );
    }

    public function display_plugin_admin_page() {
        echo '<div class="wrap">';
        echo '<h1>Hello Sun!</h1>';
        echo '<p>Bem-vindo ao ${PLUGIN_NAME}! Vamos fazer algo incrível juntos.</p>';
        echo '<button id="exemplo-botao" class="button button-primary">Clique aqui!</button>';
        echo '</div>';
        echo '<script type="text/javascript">
            document.getElementById("exemplo-botao").onclick = function() {
                alert("Olá, seja bem-vindo ao ${PLUGIN_NAME}!");
            };
        </script>';
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/admin/class-${PLUGIN_SAFE_NAME}-admin.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Admin {
    // Código do admin aqui.
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/public/class-${PLUGIN_SAFE_NAME}-public.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Public {
    // Código público aqui.
}
EOL

# Outros arquivos e diretórios
touch "$REPO_DIR/$PLUGIN_DIR/.distignore"
touch "$REPO_DIR/$PLUGIN_DIR/.editorconfig"
touch "$REPO_DIR/$PLUGIN_DIR/.gitignore"
touch "$REPO_DIR/$PLUGIN_DIR/.phpcs.xml.dist"
touch "$REPO_DIR/$PLUGIN_DIR/Gruntfile.js"
touch "$REPO_DIR/$PLUGIN_DIR/package.json"
touch "$REPO_DIR/$PLUGIN_DIR/phpunit.xml.dist"
touch "$REPO_DIR/$PLUGIN_DIR/readme.txt"
cat > "$REPO_DIR/$PLUGIN_DIR/tests/bootstrap.php" <<EOL
<?php
// Código de bootstrap para testes aqui.
EOL
cat > "$REPO_DIR/$PLUGIN_DIR/tests/test-sample.php" <<EOL
<?php
class SampleTest extends WP_UnitTestCase {
    // Exemplo de teste.
}
EOL

echo "Plugin $PLUGIN_NAME criado com sucesso na pasta $REPO_DIR/$PLUGIN_DIR"

# Auto deletar o script após execução
rm -- "$0"
