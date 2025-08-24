#!/bin/bash

# Script to push the development branch to origin
# This script should be run by someone with write access to the repository

echo "Pushing development branch to origin..."
git push -u origin dev

echo "Development branch 'dev' has been pushed to origin."
echo "Developers can now use:"
echo "  git fetch origin"
echo "  git checkout dev"
echo "to start working on the development branch."