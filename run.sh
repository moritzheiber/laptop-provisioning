#!/bin/bash

set -xue

EXTRA_VARS="${EXTRA_VARS:-}"

ansible_run_playbook() {
  echo "Running Ansible"
  ansible-playbook ansible/playbook.yml --ask-become-pass -v --connection=local --extra-vars "${EXTRA_VARS}"
}

ansible_run_playbook
