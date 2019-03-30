#!/bin/sh

# Check that everything has been committed and pushed under the ~/git
# folder. Display a summary


set -euC


HERE="$HOME/git"

SUCCESS_COLOR='\033[32m'
WARNING_COLOR='\033[33m'
FAIL_COLOR='\033[31m'
REPO_COLOR='\033[34;1m'  # bold blue
MESSAGE_COLOR="$REPO_COLOR"
WHITE='\033[0m'


trim_prefix () {
  echo "${1#$HERE/}"
}

pad="====================================================================="


print_message () {
  printf '%*.*s' 0 $(((66 - ${#1} - 4)/2)) "$pad"
  printf '( %b%s%b )' "$MESSAGE_COLOR" "$1" "$WHITE"
  printf '%*.*s' 0 $(((66 - ${#1} - 4)/2)) "$pad"
  printf '\n'
}

print_stats () {
  printf '%*.*s' 0 $(((66 - ${#1} - ${#2} - ${#3} - 16)/2)) "$pad"
  printf '( %bDone%b: %b%s%b / %b%s%b / %b%s%b )' \
    "$MESSAGE_COLOR" "$WHITE" \
    "$SUCCESS_COLOR" "$1" "$WHITE" \
    "$WARNING_COLOR" "$2" "$WHITE" \
    "$FAIL_COLOR" "$3" "$WHITE"
  printf '%*.*s' 0 $(((66 - ${#1} - ${#2} - ${#3} - 16)/2)) "$pad"
  printf '\n'
}

print_repo () {
  # INPUT:
  # $1 -- color
  # $2 -- message
  reponame="$(trim_prefix "$(pwd)")"
  printf '==( %b%s%b )' "$REPO_COLOR" "$reponame" "$WHITE"
  printf '%*.*s' 0 $((66 - ${#reponame} - 6 - ${#2} - 6)) "$pad"
  printf '( %b%s%b )==' "$1" "$2" "$WHITE"
  printf '\n'
}

get_current_branch () {
  git branch | grep '^\* ' | sed 's/^\* //'
}

git_status () {
  git status --porcelain
}

get_merge_ref () {
  branch="$(get_current_branch)"
  (git config --get "branch.$branch.merge" \
      | sed 's#^refs/heads/##') || true
}

get_remote () {
  branch="$(get_current_branch)"
  git config --get "branch.$branch.remote" || true
}

nb_ok=0
nb_warn=0
nb_err=0


print_message "Repostatus"

cd "$HERE"
# [SC2044] For loop over find output are fragile
for dirname in $(find . -type d -exec test -e '{}/.git' ';' -print -prune); do
  before_check="$(pwd)"
  cd "$dirname"
  status="$(git status --porcelain)"
  if [ "_$status" != "_" ]; then
    # Repository not clean
    nb_err=$((nb_err + 1))
    print_repo "$FAIL_COLOR" Failed
    git status
  else
    # Look for a remote branch
    branch="$(get_current_branch)"
    remote="$(get_remote)"
    merge_ref="$(get_merge_ref)"
    if [ "_$remote" = "_" ] || [ "_$merge_ref" = "_" ]; then
      # Found no remote branch
      nb_warn=$((nb_warn + 1))
      print_repo "$WARNING_COLOR" "No remote"
    else
      diff="$(git log "$remote/$merge_ref..$branch")"
      if [ "_$diff" = "_" ]; then
        nb_ok=$((nb_ok + 1))
        print_repo "$SUCCESS_COLOR" Ok
      else
        nb_err=$((nb_err + 1))
        print_repo "$FAIL_COLOR" Failed
        git status
      fi
    fi
  fi
  cd "$before_check"
done

print_stats "$nb_ok" "$nb_warn" "$nb_err"
