#!/bin/bash

set -euo pipefail

dl_dir="./dl"
contracts_repo_dir="$dl_dir/clarity-deployed-contracts"

#TODO: Clone and build latest Clarinet version in $dl_dir

echo "Getting latest version of deployed contracts..."
if [ -d "$contracts_repo_dir" ] ; then
  pushd "$contracts_repo_dir" > /dev/null
  git reset --hard HEAD
  git pull
  popd > /dev/null
else
  git clone git@github.com:boomcrypto/clarity-deployed-contracts.git "$contracts_repo_dir"
fi

echo "Checking contracts in $contracts_repo_dir before formatting..."
find "$contracts_repo_dir/contracts" -type f -print0 | while IFS= read -r -d '' file; do
  clarinet check "$file" > /dev/null || echo "❌ check failed on file pre-format: $file"
done

echo "Formatting contracts in $contracts_repo_dir..."
find "$contracts_repo_dir/contracts" -type f -print0 | while IFS= read -r -d '' file; do
  clarinet format --in-place --file "$file" > /dev/null || echo "❌ failed to format file: $file"
done

echo "Checking contracts in $contracts_repo_dir after formatting..."
find "$contracts_repo_dir/contracts" -type f -print0 | while IFS= read -r -d '' file; do
  clarinet check "$file" > /dev/null || echo "❌ check failed on file post-format: $file"
done
