#!/bin/bash
set -e

# uasge: ./release.sh x.x.x "your commit message"
VERSION=$1
COMMIT_MSG=$2

if [ -z "$VERSION" ]; then
  echo "❌ usage: ./release.sh x.x.x \"commit message\""
  exit 1
fi

if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="chore: bump version to $VERSION"
fi

echo "🔹 clean up old build files..."
rm -rf build/ dist/ *.egg-info

echo "🔹 commit code..."
git add .
git commit -m "$COMMIT_MSG"

echo "🔹 tag..."
git tag v$VERSION

echo "🔹 push code and tag..."
git push origin main --tags

echo "🔹 build pkg..."
python -m build

echo "🔹 upload to PyPI..."
twine upload --non-interactive dist/*

echo "✅ publish to: v$VERSION"
