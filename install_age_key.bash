#!/usr/bin/env bash
HOME_DIR=$1

# Check that HOME_DIR is not empty and is a valid directory
if [ -z "$HOME_DIR" ]; then
  echo "Error: HOME_DIR parameter is empty" >&2
  exit 1
fi

if [ ! -d "$HOME_DIR" ]; then
  echo "Error: $HOME_DIR is not a valid directory" >&2
  exit 1
fi

# Ensure .ssh directory exists with correct permissions
SSH_DIR="$HOME_DIR/.ssh"
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
else
  # Make sure permissions are correct even if directory already exists
  chmod 700 "$SSH_DIR"
fi

rbw get -f age_private_key "ChezMoi Dotfiles Manager" >"$HOME_DIR/.ssh/.age_private_key.txt"
chmod 600 "$HOME_DIR/.ssh/.age_private_key.txt"
