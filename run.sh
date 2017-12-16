#!/bin/bash

set -xue

EXTRA_ARGUMENTS="${1}"
EXTRA_VARS="${PROVISIONING_EXTRA_VARS:-}"

ansible_run_playbook() {
  echo "Running Ansible"
  ansible-playbook ansible/playbook.yml --ask-become-pass -v --connection=local --extra-vars "${EXTRA_VARS}" "${EXTRA_ARGUMENTS}"
}

ansible_run_playbook
