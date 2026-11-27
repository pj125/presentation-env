#!/usr/bin/env sh
# Create a new Slidev presentation from the template.
# Usage: scripts/new-presentation.sh <name>
set -eu

if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    echo "Usage: $0 <name>" >&2
    exit 1
fi

name="$1"
case "$name" in
    */* | .* )
        echo "Error: name must not contain '/' or start with '.'" >&2
        exit 1
        ;;
esac

root="$(cd "$(dirname "$0")/.." && pwd)"
target="$root/presentations/$name"

if [ -e "$target" ]; then
    echo "Error: presentation '$name' already exists at $target" >&2
    exit 1
fi

mkdir -p "$target"
sed "s/New Presentation/$(printf '%s' "$name" | sed 's/[&\\]/\\&/g')/g" \
    "$root/templates/slides.md" > "$target/slides.md"

echo "Created $target/slides.md"
echo "Start it with: PRESENTATION=$name docker compose up"
