#!/bin/sh

# Check that everything has been committed and pushed under the ~/git
# folder. Display a summary


set -euC


HERE="$HOME/git"

SUCCESS_COLOR="\033[32m"
FAIL_COLOR="\033[31m"
REPO_COLOR="\033[34;1m"  # bold blue
WHITE="\033[0m"


print_repo () {
  pad="==============================================================="
  printf '==( %b%s%b )' "$REPO_COLOR" "$repo" "$WHITE"
  printf '%*.*s' 0 $((60 - ${#1} - 6 - ${#3} - 6)) "$pad"
  printf '( %b%s%b )==' "$2" "$3" "$WHITE"
  printf '\n'
}

finish () {
  pad="==============================================================="
  printf '%*.*s' 0 $(((60 - 8)/2)) "$pad"
  printf '( %b%s%b )' "$SUCCESS_COLOR" "Done" "$WHITE"
  printf '%*.*s' 0 $(((60 - 8)/2)) "$pad"
  printf '\n'
}


check () {
  cd "$repo"
  if ! remote=$(git config --get branch.master.remote); then
      remote="origin"
  fi
  status="$(git status --porcelain)"
  diff="$(git log "$remote"/master..master)"
  if [ "_$status" = "_" ] && [ "_$diff" = "_" ]; then
    print_repo "$repo" "$SUCCESS_COLOR" Ok
  else
    print_repo "$repo" "$FAIL_COLOR" Failed
    git status
  fi
  cd "$HERE"
}

cd "$HERE"
find . -path '*/*' -prune -type d | while read -r repo
do
  check "$repo"
done

finish
