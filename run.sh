#!/bin/bash

set -e

ansible_run_playbook() {
  echo "Running Ansible"
  ansible-playbook ansible/playbook.yml --ask-become-pass -v --connection=local
}

ansible_run_playbook
