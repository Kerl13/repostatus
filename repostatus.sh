#!/bin/sh

# Check that everything has been committed and pushed under the ~/git
# folder. Display a summary


set -euC


HERE="$HOME/git"

SUCCESS_COLOR="\\033[32m"
FAIL_COLOR="\\033[31m"
REPO_COLOR="\\033[34;1m"  # bold blue
WHITE="\\033[0m"


trim_prefix () {
  echo "${1#$HERE/}"
}


print_repo () {
  pad="==============================================================="
  reponame="$(trim_prefix "$(pwd)")"
  printf '==( %b%s%b )' "$REPO_COLOR" "$reponame" "$WHITE"
  printf '%*.*s' 0 $((60 - ${#reponame} - 6 - ${#2} - 6)) "$pad"
  printf '( %b%s%b )==' "$1" "$2" "$WHITE"
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
  if ! remote=$(git config --get branch.master.remote); then
      remote="origin"
  fi
  status="$(git status --porcelain)"
  diff="$(git log "$remote"/master..master)"
  if [ "_$status" = "_" ] && [ "_$diff" = "_" ]; then
    print_repo "$SUCCESS_COLOR" Ok
  else
    print_repo "$FAIL_COLOR" Failed
    git status
  fi
}

plouf () {
  before_plouf="$(pwd)"
  cd "$1"
  if [ -d .git ]; then
    check
  else
    if [ "$(pwd)" != "$HERE" ]; then
      print_repo "$SUCCESS_COLOR" "↺"
    fi
    find . -path '*/*' -prune -type d | while read -r repo
    do
      plouf "$repo"
    done
  fi
  cd "$before_plouf"
}

plouf "$HERE"

#find . -path '*/*' -prune -type d | while read -r repo
#do
#  check "$repo"
#done

finish
