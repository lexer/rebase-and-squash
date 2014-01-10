#!/bin/sh
set -e

# Get the current branch name.
branch=`git rev-parse --abbrev-ref HEAD`
# Determine the commit at which the current branch diverged.
ancestor=`git merge-base dev HEAD`
# Stash any uncommited, changed files.
git stash --all
# Revert the branch back to the ancestor SHA.
git reset --hard $ancestor
# Squash all commits from ancestor to previous SHA.
git merge --squash HEAD@{1}
# Perform the commit, prompting for the message.
git commit -m $1
# Fetch the latest changes from the upstream branch.
git fetch origin dev
# Rebase the current single commit onto the latest.
git rebase dev
# Restore previous uncommited changes, if any.
git stash pop || true

printf "\nDone! Push with 'git push -f origin %s'\n" "$branch"

exit 0 # High five! Everything worked.