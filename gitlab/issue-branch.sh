#!/bin/bash

ISSUE_ID=$1
BASE_BRANCH=${2:-main}

if [ -z "$ISSUE_ID" ]; then
  echo "Usage: $0 <issue-id> [base-branch]"
  exit 1
fi

# Retrieve issue data using glab
ISSUE_RAW=$(glab issue view "$ISSUE_ID")
if [ $? -ne 0 ]; then
  echo "❌ Could not retrieve issue #$ISSUE_ID"
  exit 2
fi

# Determine prefix based on labels
LABELS=$(echo "$ISSUE_RAW" | grep '^labels:' | cut -d':' -f2- | tr -d ' ')
if [[ "$LABELS" == *feat* ]]; then
  PREFIX="feat/"
elif [[ "$LABELS" == *bug* ]]; then
  PREFIX="fix/"
else
  PREFIX=""
fi

# Final branch name: prefix + ISSUE_ID only
BRANCH_NAME="${PREFIX}${ISSUE_ID}"

echo "📦 Creating branch '$BRANCH_NAME' from '$BASE_BRANCH'..."
git fetch origin
git checkout -b "$BRANCH_NAME" "origin/$BASE_BRANCH"
git push -u origin "$BRANCH_NAME"

echo "✅ Done: created and pushed '$BRANCH_NAME'"
