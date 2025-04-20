#!/bin/bash

set -euo pipefail

threads=8
dl_dir="./dl"
contracts_repo_dir="$dl_dir/clarity-deployed-contracts"

#TODO: Clone and build latest Clarinet version in $dl_dir

echo "Getting latest version of deployed contracts..."
if [ -d "$contracts_repo_dir" ] ; then
  pushd "$contracts_repo_dir" > /dev/null
  git reset --hard HEAD
  git pull --quiet > /dev/null
  popd > /dev/null
else
  git clone --quiet git@github.com:boomcrypto/clarity-deployed-contracts.git "$contracts_repo_dir"
fi

echo "Checking contracts in $contracts_repo_dir before formatting..."
find "$contracts_repo_dir/contracts" -type f -print0 \
  | xargs -0 -P "$threads" -I % sh -c 'clarinet check % &> /dev/null || echo "❌ check failed on file pre-format: %"'

echo "Formatting contracts in $contracts_repo_dir..."
find "$contracts_repo_dir/contracts" -type f -print0 \
  | xargs -0 -P "$threads" -I % sh -c 'clarinet format --in-place --file % &> /dev/null || echo "❌ failed to format file: %"'

echo "Checking contracts in $contracts_repo_dir after formatting..."
find "$contracts_repo_dir/contracts" -type f -print0 \
  | xargs -0 -P "$threads" -I % sh -c 'clarinet check % &> /dev/null || echo "❌ check failed on file post-format: %"'
