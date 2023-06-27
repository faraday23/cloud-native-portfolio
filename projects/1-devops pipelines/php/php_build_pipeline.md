<!DOCTYPE html>
<html>
<head>
  <h1>Automation of Application Testing and Deployment</h1>
</head>
<body>
  <header>
    <h1>Situation:</h1>
  </header>
  <p>The company was working on its flagship product, a web application developed in PHP. The application was ready for release, but the company lacked a streamlined process for staging and production deployment, affecting the project's delivery times.</p>

  <header>
    <h1>Task:</h1>
  </header>
  <p>As a DevOps Engineer, my job was to automate the application testing, pre-production staging, and production environment deployments.</p>

  <header>
    <h1>Action:</h1>
  </header>
  <p>I formulated the depicted Bash script for the project. The script starts by setting the environment-specific variables. Then it outlines commands to clone the exact version of the project from the central Git repository, checks the code quality, runs unit tests for the application, and prepares it for a production environment. Later, it transfers the application files to the server through an SSH connection and sets suitable permissions to ensure the application runs correctly.</p>

  <header>
    <h1>Issue:</h1>
  </header>
  <p>During preparation for the production environment, issues arose indicating code inconsistencies.</p>

  <header>
    <h1>Resolution:</h1>
  </header>
  <p>The resolution involved running PHP CodeSniffer and PHP Mess Detector, which checked for coding standards violations and smelt for code issues, respectively. These tools helped to guarantee the quality of the code and conform to standards. If the tools detected any violations or issues, the script halted, necessitating the developers to eliminate the detected issues and stick to the standards before continuing with the deployment.</p>

  <header>
    <h1>Result:</h1>
  </header>
  <p>Post implementation of this script, the company saw significant improvements in their staging, testing, and production deployment timelines. Errors grew more manageable due to the automated tests and code quality checks implemented before every deployment. The production environment became more stable due to the systematized deployment process, ultimately leading to better user experience, customer satisfaction, and profitability.</p>
</body>
</html>



```shell
#!/bin/bash

# Enable strict error checking
set -euo pipefail

# Set environment variables
export APP_NAME=my-app
export APP_VERSION=1.0.0
export GIT_REPO=https://github.com/myusername/my-app.git
export SERVER_USER=myuser
export SERVER_HOST=myserver.com
export SERVER_PORT=22
export SERVER_DIR=/var/www/html/my-app
export SSH_KEY=~/.ssh/my-ssh-key.pem
export APP_ENV=test
export DB_NAME=myapp_test
export DB_USER=testuser
export DB_PASSWORD=testpassword
export DB_HOST=localhost

# Define variables
PROJECT_PATH=/path/to/project
REPORT_PATH=$PROJECT_PATH/reports
CS_STANDARD=PSR2

# Clone Git repository
git clone "$GIT_REPO"

# Checkout version tag
cd $APP_NAME && git checkout "tags/v$APP_VERSION"

# Create report directory if it does not exist
if [ ! -d "$REPORT_PATH" ]; then
  mkdir -p "$REPORT_PATH"
fi

# Run PHP CodeSniffer
echo "Running PHP CodeSniffer..."
phpcs --standard=$CS_STANDARD --report-json=$REPORT_PATH/phpcs.json $PROJECT_PATH

# Check for coding standards violations
if [ $? -ne 0 ]; then
  echo "Coding standards violations detected"
  exit 1
fi

# Run PHP Mess Detector
echo "Running PHP Mess Detector..."
phpmd $PROJECT_PATH json cleancode,codesize,controversial,design,naming,unusedcode --reportfile $REPORT_PATH/phpmd.json

# Check for code smells
if [ $? -ne 0 ]; then
  echo "Code smells detected"
  exit 1
fi

echo "Code quality analysis complete"

# Set environment variables
export APP_ENV=production
export APP_KEY=base64:a0Bc1De2Fg3Hi4Jk5Lm6Nn7Op8Qr9St0Uv1Wx2Yz3=
export APP_DEBUG=false
export APP_URL=https://example.com

# Install dependencies
composer install --no-dev --optimize-autoloader

# Run unit tests
php artisan test

# Check test status
if [ $? -ne 0 ]; then
  echo "Unit tests failed"
  exit 1
fi

# Run static code analysis
phpcs --standard=PSR12 app/

# Check analysis status
if [ $? -ne 0 ]; then
  echo "Coding standards violations detected"
fi

# Run code complexity analysis
phpmd app/ text cleancode,codesize,design

# Check analysis status
if [ $? -ne 0 ]; then
  echo "Code smells detected"
fi

# Set up environment-specific configuration
php artisan config:cache

# Optimize framework for production
php artisan optimize

# Clean up temporary files and directories
rm -rf storage/framework/cache/*
rm -rf storage/framework/sessions/*
rm -rf storage/framework/views/*
rm -rf bootstrap/cache/*

# Install dependencies
composer install

# Generate environment file
cp .env.example .env

# Migrate database
php artisan migrate

# Run unit tests
vendor/bin/phpunit

# Check test status
if [ $? -ne 0 ]; then
  echo "Unit tests failed"
  exit 1
fi

# Run unit tests
./vendor/bin/phpunit --testsuite=unit

# Run integration tests
./vendor/bin/phpunit --testsuite=integration

# Run code analysis tools
./vendor/bin/phpcs src --standard=PSR2
./vendor/bin/phpmd src text cleancode,codesize,controversial,design,naming,unusedcode
./vendor/bin/phpcpd src

# Generate code coverage report
./vendor/bin/phpunit --coverage-html coverage

# Display code coverage report
xdg-open coverage/index.html

# Check for security vulnerabilities
./vendor/bin/security-checker security:check

echo "Testing and analysis complete"

# Set up remote server
ssh -i $SSH_KEY -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "mkdir -p $SERVER_DIR"

# Deploy application files to remote server
rsync -avz -e "ssh -i $SSH_KEY -p $SERVER_PORT" --exclude '.env' --exclude 'vendor' --exclude 'node_modules' --exclude 'storage' --exclude 'bootstrap/cache' $PWD/ $SERVER_USER@$SERVER_HOST:$SERVER_DIR/

# Set file permissions on remote server
ssh -i $SSH_KEY -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "cd $SERVER_DIR && chmod -R 775 storage bootstrap/cache"

# Restart web server
ssh -i $SSH_KEY -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "sudo service apache2 restart"

# Restart web server to ensure new changes take effect
sudo service apache2 restart

echo "Build and deployment complete"
```


```json
{
  "name": "acme/my-project",
  "description": "A project for managing inventory",
  "version": "1.0.0",
  "authors": [
    {
      "name": "John Smith",
      "email": "john.smith@example.com"
    }
  ],
  "license": "MIT",
  "require": {
    "monolog/monolog": "^2.0",
    "doctrine/dbal": "^2.9"
  },
  "require-dev": {
    "phpunit/phpunit": "^8.5",
    "squizlabs/php_codesniffer": "^3.5"
  },
  "autoload": {
    "psr-4": {
      "Acme\\": "src/"
    }
  },
  "scripts": {
    "post-install-cmd": [
      "My\\Custom\\Script::postInstall"
    ]
  },
  "repositories": [
    {
      "type": "vcs",
      "url": "https://github.com/acme/my-package"
    }
  ],
  "config": {
    "preferred-install": "dist",
    "optimize-autoloader": true
  }
}
```