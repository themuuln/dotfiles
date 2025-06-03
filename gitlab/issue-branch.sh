#!/bin/bash

ISSUE_ID=$1
BASE_BRANCH=${2:-main}

if [ -z "$ISSUE_ID" ]; then
  echo "Usage: $0 <issue-id> [base-branch]"
  exit 1
fi

# Retrieve issue text and extract the title (first line)
ISSUE_RAW=$(glab issue view "$ISSUE_ID")
if [ $? -ne 0 ]; then
  echo "❌ Could not retrieve issue #$ISSUE_ID"
  exit 2
fi

# Get the first non-empty line, assuming it's the title
ISSUE_TITLE=$(echo "$ISSUE_RAW" | awk 'NF {print; exit}')
if [ -z "$ISSUE_TITLE" ]; then
  echo "❌ Could not parse title from issue #$ISSUE_ID"
  exit 3
fi

# Slugify
SLUG=$(echo "$ISSUE_TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')
BRANCH_NAME="${ISSUE_ID}-${SLUG}"

echo "📦 Creating branch '$BRANCH_NAME' from '$BASE_BRANCH'..."
git fetch origin
git checkout -b "$BRANCH_NAME" "origin/$BASE_BRANCH"
git push -u origin "$BRANCH_NAME"

echo "✅ Done: created and pushed '$BRANCH_NAME'"
