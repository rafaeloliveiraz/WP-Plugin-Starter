#!/bin/bash

# Define el directorio donde se ejecutará el script
REPO_DIR="$(pwd)"

# Solicita el nombre del plugin al usuario
read -p "Ingrese el nombre del plugin (Ej: Mi Plugin): " PLUGIN_NAME
PLUGIN_DIR="${PLUGIN_NAME// /-}"
PLUGIN_DIR=$(echo "$PLUGIN_DIR" | tr '[:upper:]' '[:lower:]')
PLUGIN_SAFE_NAME=$(echo "$PLUGIN_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
PLUGIN_CLASS_SAFE_NAME=$(echo "$PLUGIN_NAME" | tr ' ' '_')

# Verifica si el directorio del plugin ya existe
if [ -d "$REPO_DIR/$PLUGIN_DIR" ]; then
  echo "El directorio $PLUGIN_DIR ya existe. Por favor, elija otro nombre."
  exit 1
fi

# Crea el directorio del plugin dentro del directorio definido en $REPO_DIR
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

# Solicita información adicional al usuario
read -p "Ingrese el nombre del autor: " AUTHOR_NAME
read -p "Ingrese el sitio web del autor: " AUTHOR_URI
read -p "Ingrese la versión del plugin (Ej: 1.0): " PLUGIN_VERSION

# Añade "(WP Plugin Starter)" al nombre del autor
AUTHOR_NAME="$AUTHOR_NAME (WP Plugin Starter)"

# Función para convertir a mayúsculas
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Función para convertir a PascalCase
to_pascal_case() {
    echo "$1" | sed -r 's/(^|_)(\w)/\U\2/g'
}

PLUGIN_CONST=$(to_upper "$PLUGIN_SAFE_NAME")
PLUGIN_CLASS=$(to_pascal_case "$PLUGIN_CLASS_SAFE_NAME")

# Crea los archivos principales del plugin
cat > "$REPO_DIR/$PLUGIN_DIR/${PLUGIN_SAFE_NAME}.php" <<EOL
<?php
/**
 * Plugin Name: ${PLUGIN_NAME}
 * Plugin URI: https://github.com/rafaeloliveiraz/WP-Plugin-Starter
 * Description: Este plugin fue iniciado utilizando la herramienta WP Plugin Starter desarrollada por Rafael Oliveira. Aprende más en https://github.com/rafaeloliveiraz/WP-Plugin-Starter
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

# Crea las clases de activación, desactivación y la clase principal del plugin
cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}-activator.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Activator {
    public static function activate() {
        // Código de activación aquí.
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}-deactivator.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Deactivator {
    public static function deactivate() {
        // Código de desactivación aquí.
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
        echo '<p>Bienvenido a ${PLUGIN_NAME}! Hagamos algo increíble juntos.</p>';
        echo '<button id="example-button" class="button button-primary">¡Haz clic aquí!</button>';
        echo '</div>';
        echo '<script type="text/javascript">
            document.getElementById("example-button").onclick = function() {
                alert("¡Hola, bienvenido a ${PLUGIN_NAME}!");
            };
        </script>';
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/admin/class-${PLUGIN_SAFE_NAME}-admin.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Admin {
    // Código del admin aquí.
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/public/class-${PLUGIN_SAFE_NAME}-public.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Public {
    // Código público aquí.
}
EOL

# Otros archivos y directorios
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
// Código de bootstrap para pruebas aquí.
EOL
cat > "$REPO_DIR/$PLUGIN_DIR/tests/test-sample.php" <<EOL
<?php
class SampleTest extends WP_UnitTestCase {
    // Prueba de ejemplo.
}
EOL

echo "Plugin $PLUGIN_NAME creado con éxito en el directorio $REPO_DIR/$PLUGIN_DIR"

# Eliminar automáticamente el script después de la ejecución
rm -- "$0"
