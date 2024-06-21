#!/bin/bash

# Verifica se o nome do plugin foi fornecido
if [ -z "$1" ]; then
  echo "Uso: $0 nome-do-plugin"
  exit 1
fi

PLUGIN_NAME=$1
PLUGIN_DIR="${PLUGIN_NAME// /-}"

# Pergunta informações ao usuário
read -p "Digite o URI do plugin: " PLUGIN_URI
read -p "Digite o nome do autor: " AUTHOR_NAME
read -p "Digite o site do autor: " AUTHOR_URI
read -p "Digite a versão do plugin: " PLUGIN_VERSION

# Cria o diretório do plugin
mkdir -p "$PLUGIN_DIR"
mkdir -p "$PLUGIN_DIR/includes"
mkdir -p "$PLUGIN_DIR/admin"
mkdir -p "$PLUGIN_DIR/public"
mkdir -p "$PLUGIN_DIR/assets/css"
mkdir -p "$PLUGIN_DIR/assets/js"
mkdir -p "$PLUGIN_DIR/assets/images"
mkdir -p "$PLUGIN_DIR/languages"
mkdir -p "$PLUGIN_DIR/tests"
mkdir -p "$PLUGIN_DIR/.circleci"
mkdir -p "$PLUGIN_DIR/bin"

# Cria os arquivos principais do plugin
cat > "$PLUGIN_DIR/${PLUGIN_DIR}.php" <<EOL
<?php
/**
 * Plugin Name: ${PLUGIN_NAME}
 * Plugin URI: ${PLUGIN_URI}
 * Description: Este plugin foi iniciado através da ferramenta WP Plugin Starter desenvolvida por Rafael Oliveira. Veja mais em https://github.com/XXX
 * Version: ${PLUGIN_VERSION}
 * Author: ${AUTHOR_NAME}
 * Author URI: ${AUTHOR_URI}
 * License: GPL2
 */

if (!defined('WPINC')) {
    die;
}

define('${PLUGIN_DIR^^}_VERSION', '${PLUGIN_VERSION}');

function activate_${PLUGIN_DIR}() {
    require_once plugin_dir_path(__FILE__) . 'includes/class-${PLUGIN_DIR}-activator.php';
    ${PLUGIN_DIR^}_Activator::activate();
}
register_activation_hook(__FILE__, 'activate_${PLUGIN_DIR}');

function deactivate_${PLUGIN_DIR}() {
    require_once plugin_dir_path(__FILE__) . 'includes/class-${PLUGIN_DIR}-deactivator.php';
    ${PLUGIN_DIR^}_Deactivator::deactivate();
}
register_deactivation_hook(__FILE__, 'deactivate_${PLUGIN_DIR}');

require plugin_dir_path(__FILE__) . 'includes/class-${PLUGIN_DIR}.php';

function run_${PLUGIN_DIR}() {
    \$plugin = new ${PLUGIN_DIR^}();
    \$plugin->run();
}
run_${PLUGIN_DIR}();
EOL

# Cria as classes de ativação, desativação e a classe principal do plugin
cat > "$PLUGIN_DIR/includes/class-${PLUGIN_DIR}-activator.php" <<EOL
<?php
class ${PLUGIN_DIR^}_Activator {
    public static function activate() {
        // Código de ativação aqui.
    }
}
EOL

cat > "$PLUGIN_DIR/includes/class-${PLUGIN_DIR}-deactivator.php" <<EOL
<?php
class ${PLUGIN_DIR^}_Deactivator {
    public static function deactivate() {
        // Código de desativação aqui.
    }
}
EOL

cat > "$PLUGIN_DIR/includes/class-${PLUGIN_DIR}.php" <<EOL
<?php
class ${PLUGIN_DIR^} {
    public function run() {
        // Inicialize o plugin aqui.
    }
}
EOL

cat > "$PLUGIN_DIR/admin/class-${PLUGIN_DIR}-admin.php" <<EOL
<?php
class ${PLUGIN_DIR^}_Admin {
    // Código do admin aqui.
}
EOL

cat > "$PLUGIN_DIR/public/class-${PLUGIN_DIR}-public.php" <<EOL
<?php
class ${PLUGIN_DIR^}_Public {
    // Código público aqui.
}
EOL

# Outros arquivos e diretórios
touch "$PLUGIN_DIR/.distignore"
touch "$PLUGIN_DIR/.editorconfig"
touch "$PLUGIN_DIR/.gitignore"
touch "$PLUGIN_DIR/.phpcs.xml.dist"
touch "$PLUGIN_DIR/Gruntfile.js"
touch "$PLUGIN_DIR/package.json"
touch "$PLUGIN_DIR/phpunit.xml.dist"
touch "$PLUGIN_DIR/readme.txt"
cat > "$PLUGIN_DIR/tests/bootstrap.php" <<EOL
<?php
// Código de bootstrap para testes aqui.
EOL
cat > "$PLUGIN_DIR/tests/test-sample.php" <<EOL
<?php
class SampleTest extends WP_UnitTestCase {
    // Exemplo de teste.
}
EOL

echo "Plugin $PLUGIN_NAME criado com sucesso na pasta $PLUGIN_DIR"
