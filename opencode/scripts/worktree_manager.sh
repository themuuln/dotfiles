#!/bin/bash

# worktree_manager.sh - Enhanced Worktree Management for OpenCode
# Inspired by opencode-worktree plugin

COMMAND=$1
BRANCH=$2
BASE_REPO_PATH=$(pwd)
PROJECT_NAME=$(basename "$BASE_REPO_PATH")
WORKTREE_BASE_DIR="$HOME/.opencode_worktrees/$PROJECT_NAME"

function show_usage() {
    echo "Usage: $0 {create|cleanup} <branch_name>"
    exit 1
}

if [[ -z "$COMMAND" || -z "$BRANCH" ]]; then
    show_usage
fi

case "$COMMAND" in
    create)
        echo "[Worktree] Creating worktree for branch: $BRANCH"
        
        # 1. Define Path
        WORKTREE_PATH="$WORKTREE_BASE_DIR/$BRANCH"
        mkdir -p "$WORKTREE_BASE_DIR"

        # 2. Git Worktree Add
        if git worktree add "$WORKTREE_PATH" "$BRANCH" 2>/dev/null; then
            echo "[Worktree] Created new worktree at $WORKTREE_PATH"
        else
            # Try creating branch if it doesn't exist
            echo "[Worktree] Branch might not exist, trying to create from HEAD..."
            git worktree add -b "$BRANCH" "$WORKTREE_PATH"
        fi

        # 3. Sync Environment (Instant Start)
        echo "[Worktree] Syncing environment..."
        
        # Symlink node_modules
        if [[ -d "$BASE_REPO_PATH/node_modules" ]]; then
            ln -s "$BASE_REPO_PATH/node_modules" "$WORKTREE_PATH/node_modules"
            echo "[Worktree] Symlinked node_modules"
        fi

        # Copy .env files
        find "$BASE_REPO_PATH" -maxdepth 1 -name ".env*" -exec cp {} "$WORKTREE_PATH/" \;
        echo "[Worktree] Copied .env files"

        # 4. tmux Integration
        if [[ -n "$TMUX" ]]; then
            tmux new-window -n "OC:$BRANCH" -c "$WORKTREE_PATH"
            echo "[Worktree] Spawned new tmux window: OC:$BRANCH"
        fi

        echo "[Worktree] Setup complete. Please: cd $WORKTREE_PATH"
        ;;

    cleanup)
        echo "[Worktree] Cleaning up worktree for branch: $BRANCH"
        WORKTREE_PATH="$WORKTREE_BASE_DIR/$BRANCH"

        if [[ ! -d "$WORKTREE_PATH" ]]; then
            echo "[Error] Worktree directory not found: $WORKTREE_PATH"
            exit 1
        fi

        # 1. Snapshot Changes (Safety First)
        echo "[Worktree] Taking snapshot..."
        pushd "$WORKTREE_PATH" > /dev/null
        git add .
        git commit -m "chore: worktree snapshot [$(date +'%Y-%m-%d %H:%M:%S')]" --no-verify || echo "[Worktree] No changes to snapshot"
        
        # 2. Push for safety
        CURRENT_REMOTE=$(git remote)
        if [[ -n "$CURRENT_REMOTE" ]]; then
            git push origin "$BRANCH" || echo "[Worktree] Failed to push snapshot (normal if remote doesn't exist)"
        fi
        popd > /dev/null

        # 3. Remove Worktree
        git worktree remove --force "$WORKTREE_PATH"
        echo "[Worktree] Removed worktree from git"

        # 4. Final Cleanup
        rm -rf "$WORKTREE_PATH"
        echo "[Worktree] Deleted directory: $WORKTREE_PATH"
        
        echo "[Worktree] Cleanup complete."
        ;;

    *)
        show_usage
        ;;
esac
