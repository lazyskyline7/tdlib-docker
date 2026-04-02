#!/usr/bin/env bash

# Define the path to CMakeLists.txt
CMAKE_LISTS_FILE="CMakeLists.txt"

# Check if CMakeLists.FILE exists
if [ ! -f "$CMAKE_LISTS_FILE" ]; then
  echo "Error: $CMAKE_LISTS_FILE not found in the current directory."
  exit 1
fi

# Extract the version from CMakeLists.txt using awk
# The version is in the format: project(TDLib VERSION X.Y.Z LANGUAGES CXX C)
TDLIB_VERSION=$(awk '/project\(TDLib VERSION/ {print $3}' "$CMAKE_LISTS_FILE")

# Remove the 'VERSION' keyword if it's still present and any trailing 'LANGUAGES'
TDLIB_VERSION=$(echo "$TDLIB_VERSION" | sed 's/VERSION//g' | sed 's/LANGUAGES//g')

# Clean up any extra spaces or parentheses
TDLIB_VERSION=$(echo "$TDLIB_VERSION" | tr -d '[:space:]()')


# Check if version was extracted successfully
if [ -z "$TDLIB_VERSION" ]; then
  echo "Error: Could not extract TDLib version from $CMAKE_LISTS_FILE."
  exit 1
fi

# Construct the tag name
GIT_TAG_NAME="$TDLIB_VERSION"

echo "Detected TDLib version: $TDLIB_VERSION"

# Update version badge in README.md
README_FILE="README.md"
if [ -f "$README_FILE" ]; then
  sed -i '' "s|TDLib-[0-9][0-9.]*-blue|TDLib-${TDLIB_VERSION}-blue|g" "$README_FILE"
  echo "Updated version badge in $README_FILE to $TDLIB_VERSION."
else
  echo "Warning: $README_FILE not found, skipping badge update."
fi

echo "Attempting to add Git tag: $GIT_TAG_NAME"

# Check if the tag already exists
if git rev-parse --verify --quiet "$GIT_TAG_NAME" >/dev/null; then
  echo "Error: Git tag '$GIT_TAG_NAME' already exists."
  exit 1
fi

# Add the Git tag
git tag "$GIT_TAG_NAME"

if [ $? -eq 0 ]; then
  echo "Successfully added Git tag '$GIT_TAG_NAME'."
  echo "You can push the tag to the remote repository using: git push origin $GIT_TAG_NAME"
else
  echo "Error: Failed to add Git tag '$GIT_TAG_NAME'."
  exit 1
fi
