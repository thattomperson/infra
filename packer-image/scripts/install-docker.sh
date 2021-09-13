#!/bin/bash
# This script can be used to install Nomad and its dependencies. This script has been tested with the following
# operating systems:
#
# 1. Debian 10

readonly SCRIPT_NAME="$(basename "$0")"

function log {
  local readonly level="$1"
  local readonly message="$2"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local readonly message="$1"
  log "INFO" "$message"
}

function log_warn {
  local readonly message="$1"
  log "WARN" "$message"
}

function log_error {
  local readonly message="$1"
  log "ERROR" "$message"
}

function install_dependencies {
  log_info "Installing Docker dependancies"
  apt-get update
  apt-get install -yp apt-transport-https ca-certificates curl gnupg lsb-release
}

function install {
  install_dependencies

  log_info "Downloading Docker GPG key"
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  log_info "Setting up Docker stable repository"
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


  log_info "Updating apt-get database"
  apt-get update
  log_info "Installing docker"
  apt-get install -yq docker-ce docker-ce-cli containerd.io


  log_info "Adding nomad user to the docker group"
  sudo usermod -G docker -a nomad


  log_info "Docker install complete!"
}

install "$@"