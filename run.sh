#!/bin/bash

set -e

ansible_run_playbook() {
  echo "Running Ansible"
  ansible-playbook ansible/playbook.yml -i ansible/hosts --ask-become-pass -v
}

ansible_run_playbook
