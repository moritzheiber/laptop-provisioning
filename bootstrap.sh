#!/bin/bash

set -eu -o pipefail

declare -a DEPS=(
python-pip
python-apt
libffi-dev
libssl-dev
build-essential
python-virtualenv
python-setuptools
python3-setuptools
)

ansible_deps() {
  echo "Installing Python dependencies"

  for dep in "${DEPS[@]}" ; do
    if ! dpkg -s "${dep}" &> /dev/null ; then
      sudo apt install -y "${dep}"
    fi
  done

  if ! ansible-playbook --version ; then
    pip install --user --upgrade ansible
  fi
}

echo "Updating index"
sudo apt update -qq
ansible_deps

./run.sh
