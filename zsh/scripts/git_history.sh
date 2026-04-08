#!/bin/zsh

# Get today's date in ISO format
TODAY=$1

# Get the current user's git email to filter commits
GIT_EMAIL=$(git config user.email)

echo "==================================="
echo "Commit Activity Report for $TODAY"
echo "Author: $GIT_EMAIL"
echo "==================================="
echo ""

# Counter for total commits
TOTAL_COMMITS=0
TOTAL_BRANCHES=0

# Loop through all directories in ~/github
for repo in ~/github/*/; do
  # Check if it's a git repository
  if [ -d "$repo/.git" ]; then
    cd "$repo" || continue
    
    # Get the folder name
    FOLDER_NAME=$(basename "$repo")
    
    # Get all commits from today with their branch decorations in one efficient query
    BRANCH_DATA=$(git log --all --author="$GIT_EMAIL" --since="$TODAY 00:00:00" --until="$TODAY 23:59:59" --format="%D" 2>/dev/null | \
      grep -v "^$" | \
      tr ',' '\n' | \
      sed 's/^ *//;s/ *$//' | \
      grep -E '^(HEAD ->|origin/|refs/heads/)' | \
      sed 's/HEAD -> //;s|origin/||;s|refs/heads/||' | \
      sort | uniq -c | \
      awk '{print $2":"$1}')
    
    # Only display repositories with commits today
    if [ -n "$BRANCH_DATA" ]; then
      echo "📁 Repository: $FOLDER_NAME"
      
      REPO_COMMIT_COUNT=0
      REPO_BRANCH_COUNT=0
      
      echo "$BRANCH_DATA" | while IFS=':' read branch count; do
        if [ -n "$branch" ]; then
          echo "   🌿 $branch: $count commit(s)"
          REPO_COMMIT_COUNT=$((REPO_COMMIT_COUNT + count))
          REPO_BRANCH_COUNT=$((REPO_BRANCH_COUNT + 1))
        fi
      done
      
      REPO_COMMIT_COUNT=$(echo "$BRANCH_DATA" | awk -F: '{sum+=$2} END {print sum}')
      REPO_BRANCH_COUNT=$(echo "$BRANCH_DATA" | wc -l | tr -d ' ')
      
      echo "   📊 Total: $REPO_COMMIT_COUNT commits across $REPO_BRANCH_COUNT branch(es)"
      echo ""
      
      # List all individual commits
      echo "   Commit Details:"
      GIT_PAGER=cat git log --all --author="$GIT_EMAIL" --since="$TODAY 00:00:00" --until="$TODAY 23:59:59" \
        --format="      %h - %s (%ar)" 2>/dev/null
      echo ""
      
      TOTAL_COMMITS=$((TOTAL_COMMITS + REPO_COMMIT_COUNT))
      TOTAL_BRANCHES=$((TOTAL_BRANCHES + REPO_BRANCH_COUNT))
    fi
  fi
done

echo "==================================="
echo "Total commits today: $TOTAL_COMMITS"
echo "Total branches worked on: $TOTAL_BRANCHES"
echo "==================================="
