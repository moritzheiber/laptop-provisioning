#!/bin/bash

set -eu -o pipefail

ANSIBLE_VERSION="2.4.4.0"

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

  if ! ansible-playbook --version | grep -q "${ANSIBLE_VERSION}" ; then
    pip install --user --upgrade ansible=="${ANSIBLE_VERSION}"
  fi
}

echo "Updating index"
sudo apt update -qq
ansible_deps

./run.sh
