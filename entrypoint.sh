#!/bin/sh

set -eu

export GITHUB="true"

sh -c "/bin/deploy-k8s $*"
