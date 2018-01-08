#!/bin/bash

set -eo

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

installed() {
  local dep="$1"

  dpkg --get-selections | grep -q "${dep}"
}

ansible_deps() {
  echo "Installing Python dependencies"

  for dep in ${DEPS[@]} ; do
    if ! installed "${dep}" ; then
      sudo apt-get install -y "${dep}"
    fi
  done

  if [ ! -x "${HOME}/.local/bin/ansible-playbook" ] ; then
    pip install --user --upgrade ansible==2.3.2.0
  fi
}

sudo apt-get update

ansible_deps

./run.sh
