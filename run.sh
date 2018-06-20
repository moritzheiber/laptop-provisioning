#!/bin/bash

set -xue

ANSIBLE_REMOTE_TEMP="/tmp/.ansible-${USER}/tmp"
EXTRA_ARGUMENTS="${1:-}"
EXTRA_VARS="${PROVISIONING_EXTRA_VARS:-}"
export ANSIBLE_REMOTE_TEMP

ansible_run_playbook() {
  echo "Running Ansible"
  ansible-playbook ansible/playbook.yml \
    --ask-become-pass \
    -vvvv \
    -i localhost, \
    --connection=local \
    --extra-vars "${EXTRA_VARS}" \
    ${EXTRA_ARGUMENTS}
}

ansible_run_playbook
