#!/bin/bash

set -eu -o pipefail

MITAMAE_PATH="/usr/bin/mitamae"
MITAMAE_VERSION="1.5.6"
MITAMAE_CHECKSUM="585a1ff05e1a8a8a39434bd6b576940d2f850dbd9960c1d493698d3f1df95f1f"
LOG_LEVEL="${LOG_LEVEL:-info}"

_cleanup() {
  rm -f /tmp/mitamae
}

install_mitamae() {
  trap _cleanup EXIT TERM

  if ! [ -x "${MITAMAE_PATH}" ] ; then
    wget -O /tmp/mitamae "https://github.com/itamae-kitchen/mitamae/releases/download/v${MITAMAE_VERSION}/mitamae-x86_64-linux" &&
    echo "${MITAMAE_CHECKSUM}  /tmp/mitamae" | sha256sum -c - &&
    sudo install -m 0755 /tmp/mitamae "${MITAMAE_PATH}"
  fi
}

install_mitamae

(
  cd mitamae/
  sudo mitamae local -l "${LOG_LEVEL}" --node-yaml vars.yml mitamae.rb
)
