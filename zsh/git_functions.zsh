source $ZDOTDIR/utils.zsh

# Extracts the Jira Ticket ID from the current branch name. type/KEY-123/description' -> KEY-123.
function git:jira_branch() {
  branch=$(git:current-branch)
  ticket=$(echo "$branch" | grep -oE "[A-Z]+-[0-9]+")
  # Return the value
  echo $ticket
}

# Gets the current git branch name.
function git:current-branch() {
  echo $(git branch --show-current)
}

# Retrieves the default git branch for the git repo.
function git:default-branch() {
  echo $(GH_PAGER=cat gh repo view --json defaultBranchRef -q '.defaultBranchRef.name')
}

# Retrieves the base url for the git repo.
function git:base-url() {
  echo $(GH_PAGER=cat gh repo view --json url -q '.url')
}

# Constructs the title that should be used when creating a new PR.
function git:pr-title() {
  branch=$(git:current-branch)
  jira=$(echo "$branch" | grep -oE '[A-Z]+-[0-9]+')
  title=$(echo "$branch" | sed -E 's|.*/[A-Z]+-[0-9]+-||;s|^[A-Z]+-[0-9]+-||;s|.*/||' | tr '-' ' ' | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}}1')
  
  if [ -n "$jira" ]; then
    echo "${jira}: ${title}"
  else
    echo "${title}"
  fi
}

# Retrieves all the new commit-messages made to the current branch with respect to the repo's default branch.
function git:commit-messages() {
  root_branch=$(git:default-branch)
  GIT_PAGER=cat git log origin/${root_branch}..HEAD --format=%B
}

# Constructs the PR's body that should be used when creating a new PR.
function git:pr-body() {
  root_branch=$(git:default-branch)

  changeset_body=$(GIT_PAGER=cat git diff origin/${root_branch}..HEAD --name-status | awk '$1 == "A" && $2 ~ /^\.changeset\/.*\.md$/ {print $2}' | xargs cat | awk '/^---$/ {inblock = !inblock; next} !inblock')
  
  if [ -n "$changeset_body" ]; then
    echo "${changeset_body}"
  else
    commit_messages=$(git:commit-messages)
    echo "${commit_messages}"
  fi
}

# Creates a new PR constructing a title and body.
function git:create-pr() {
  gh pr create --title "$(git:pr-title)" --body "$(git:pr-body)"
}

# Opens GH to compare the current branch against the default branch of the repo.
function git:compare-branch() {
  root_branch=$(git:default-branch)
  current_branch=$(git:current-branch)

  git:compare-gh $root_branch $current_branch
}

# Opens GH to compare 1 or 2 different tags within the repo.
# When 1 tag is provided, will compare the tag against the default branch.
# When 2 tags are provided, will compare each other tag_1 <- tag_2
# Examples:
# `git:compare-tags tag_1`
# `git:compare-tags tag_1 tag_2`
function git:compare-tags() {
  tag_1=$1
  tag_2=$2


  if [ -n "$tag_2" ]; then
    git:compare-gh $tag_1 $tag_2
  else
    root_branch=$(git:default-branch)
    git:compare-gh $root_branch $tag_1
  fi
}

# Opens URL to compare 2 tags against each other.
# Example: `git:compare-gh tag_1 tag_2`
function git:compare-gh() {
  base_url=$(git:base-url)
  compare_1=$1
  compare_2=$2

  open $base_url/compare/$1...$2
}

# Compiles an easy to read report of all git activity I made on a specific date
# Example: `git:history 2026-01-01`
function git:history() {
  $ZDOTDIR/scripts/git_history.sh $1
}

# Prints out help dialogue for all git functions.
function git:help() {
  zsh-help ${(%):-%x}
}