#!/usr/bin/env sh
set -eu

/setup-ssh.sh

if test -n "$INPUT_GIT_CREDENTIALS"; then
  echo $INPUT_GIT_CREDENTIALS > ~/.git-credentials
  git config credential.helper store
fi
export GIT_SSH_COMMAND="ssh -v -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -l $INPUT_SSH_USERNAME"
git remote add mirror "$INPUT_TARGET_REPO_URL"
git push --tags --force --prune mirror "refs/remotes/origin/*:refs/heads/*"

# NOTE: Since `post` execution is not supported for local action from './' for now, we need to
# run the command by hand.
/cleanup.sh mirror
