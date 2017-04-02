#!/bin/bash

set -exo

declare -a DEPS=(
python-pip
python-apt
libffi-dev
libssl-dev
build-essential
python-virtualenv
python-setuptools
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
    pip install --user --upgrade ansible==2.2.2.0
  fi
}

ansible_run_playbook() {
  echo "Running Ansible"
  ansible-playbook ansible/playbook.yml -i ansible/hosts --ask-become-pass -vv
}

sudo apt-get update

ansible_deps
ansible_run_playbook
