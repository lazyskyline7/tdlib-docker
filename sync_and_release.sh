#!/usr/bin/env bash
set -euo pipefail

# Ensure clean working tree
if [ -n "$(git status --porcelain)" ]; then
    echo "Error: Working tree is not clean. Commit or stash changes first."
    exit 1
fi

# Ensure merge=ours driver is configured (needed for README.md)
git config merge.ours.driver true

# 1. Fetch upstream
echo "==> Fetching upstream..."
git fetch upstream

# 2. Fast-forward master to upstream/master
echo "==> Updating master..."
git checkout master
git merge --ff-only upstream/master

# 3. Merge master into build (README auto-resolved via merge=ours)
echo "==> Merging master into build..."
git checkout build
git merge master

# 4. Create tag from version in CMakeLists.txt
echo "==> Creating tag..."
./add_git_tag.sh

# Extract version for push
VERSION=$(awk '/project\(TDLib VERSION/ {print $3}' CMakeLists.txt | tr -d '[:space:]()')

# 5. Summary
echo ""
echo "========================================="
echo "  Ready to push"
echo "========================================="
echo "  master  → origin/master"
echo "  build   → origin/build"
echo "  tag     → ${VERSION}"
echo "========================================="
echo ""
read -p "Push all? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin master build -f "${VERSION}"
    echo ""
    echo "Done! CI/CD will build and release ${VERSION}."
else
    echo "Aborted. You can push manually:"
    echo "  git push origin master build ${VERSION}"
fi
