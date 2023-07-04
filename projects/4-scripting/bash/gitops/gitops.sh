# This script assumes that your Git repository contains the application configuration files in a subdirectory called config, and that the configuration files are in one of the supported formats (YAML, JSON, or environment files).

# The script first clones the repository or pulls the latest changes, and then checks for any local changes that have not been committed or pushed to the repository. If there are any local changes, the script exits and prompts the user to either commit or revert the changes.

# Next, the script updates the configuration files based on the latest version in the repository. For each configuration file, the script compares the local version to the version in the repository and updates the local version if necessary. If there are no changes, the script removes the temporary file.

# Finally, the script commits any changes to the repository and pushes them to the remote branch. If there are no changes, the script outputs a message indicating that no changes were detected.


#!/bin/bash

# Set default values
CONFIG_DIR="./config"
GIT_BRANCH="main"
GIT_REMOTE="origin"

# Clone or pull the repository
if [ -d "$CONFIG_DIR" ]; then
  cd "$CONFIG_DIR"
  git pull
else
  git clone -b "$GIT_BRANCH" "$GIT_REMOTE" "$CONFIG_DIR"
  cd "$CONFIG_DIR"
fi

# Check for any local changes
if ! git diff --quiet; then
  echo "Local changes detected. Please commit or revert changes before continuing."
  exit 1
fi

# Update the configuration files based on the repository
find . -name '*.yaml' -or -name '*.yml' -or -name '*.json' -or -name '*.env' | while read -r file; do
  git show "$GIT_BRANCH:$file" > "$file.tmp"
  if ! diff "$file" "$file.tmp" > /dev/null; then
    echo "Updating $file"
    mv "$file.tmp" "$file"
  else
    rm "$file.tmp"
  fi
done

# Commit any changes and push to the repository
if ! git diff --quiet; then
  git add .
  git commit -m "Updated configuration files"
  git push "$GIT_REMOTE" "$GIT_BRANCH"
  echo "Changes committed and pushed to repository."
else
  echo "No changes detected."
fi
