#!/bin/bash

# Define the directory where the script will be executed
REPO_DIR="$(pwd)"

# Prompt the user for the plugin name
read -p "Enter the plugin name (e.g., My Plugin): " PLUGIN_NAME
PLUGIN_DIR="${PLUGIN_NAME// /-}"
PLUGIN_DIR=$(echo "$PLUGIN_DIR" | tr '[:upper:]' '[:lower:]')
PLUGIN_SAFE_NAME=$(echo "$PLUGIN_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
PLUGIN_CLASS_SAFE_NAME=$(echo "$PLUGIN_NAME" | tr ' ' '_')

# Check if the plugin directory already exists
if [ -d "$REPO_DIR/$PLUGIN_DIR" ]; then
  echo "The directory $PLUGIN_DIR already exists. Please choose another name."
  exit 1
fi

# Create the plugin directory within the defined directory in $REPO_DIR
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

# Prompt the user for additional information
read -p "Enter the author name: " AUTHOR_NAME
read -p "Enter the author website: " AUTHOR_URI
read -p "Enter the plugin version (e.g., 1.0): " PLUGIN_VERSION

# Add "(WP Plugin Starter)" to the author name
AUTHOR_NAME="$AUTHOR_NAME (WP Plugin Starter)"

# Function to convert to uppercase
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to convert to PascalCase
to_pascal_case() {
    echo "$1" | sed -r 's/(^|_)(\w)/\U\2/g'
}

PLUGIN_CONST=$(to_upper "$PLUGIN_SAFE_NAME")
PLUGIN_CLASS=$(to_pascal_case "$PLUGIN_CLASS_SAFE_NAME")

# Create the main plugin files
cat > "$REPO_DIR/$PLUGIN_DIR/${PLUGIN_SAFE_NAME}.php" <<EOL
<?php
/**
 * Plugin Name: ${PLUGIN_NAME}
 * Plugin URI: https://github.com/rafaeloliveiraz/WP-Plugin-Starter
 * Description: This plugin was started using the WP Plugin Starter tool developed by Rafael Oliveira. Learn more at https://github.com/rafaeloliveiraz/WP-Plugin-Starter
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

# Create the activation, deactivation, and main plugin classes
cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}-activator.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Activator {
    public static function activate() {
        // Activation code here.
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/includes/class-${PLUGIN_SAFE_NAME}-deactivator.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Deactivator {
    public static function deactivate() {
        // Deactivation code here.
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
        echo '<p>Welcome to ${PLUGIN_NAME}! Let\'s do something amazing together.</p>';
        echo '<button id="example-button" class="button button-primary">Click here!</button>';
        echo '</div>';
        echo '<script type="text/javascript">
            document.getElementById("example-button").onclick = function() {
                alert("Hello, welcome to ${PLUGIN_NAME}!");
            };
        </script>';
    }
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/admin/class-${PLUGIN_SAFE_NAME}-admin.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Admin {
    // Admin code here.
}
EOL

cat > "$REPO_DIR/$PLUGIN_DIR/public/class-${PLUGIN_SAFE_NAME}-public.php" <<EOL
<?php
class ${PLUGIN_CLASS}_Public {
    // Public code here.
}
EOL

# Other files and directories
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
// Bootstrap code for tests here.
EOL
cat > "$REPO_DIR/$PLUGIN_DIR/tests/test-sample.php" <<EOL
<?php
class SampleTest extends WP_UnitTestCase {
    // Sample test.
}
EOL

echo "Plugin $PLUGIN_NAME successfully created in the directory $REPO_DIR/$PLUGIN_DIR"

# Auto delete the script after execution
rm -- "$0"
