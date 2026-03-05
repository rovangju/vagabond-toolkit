#!/bin/bash

# Usage: ./extrapolate-helm-images.sh <helm-file> <output-file>
# Extracts all container images from Helm charts listed in the input file

HELM_FILE="${1:-helm}"
OUTPUT_FILE="${2:-images}"

if [[ ! -f "$HELM_FILE" ]]; then
    echo "Error: Helm file '$HELM_FILE' not found" >&2
    exit 1
fi

> "$OUTPUT_FILE"

while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    chart=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')
    helm template "$chart" --version "$version" 2>/dev/null | grep -oE 'image: [^"]+' | sed 's/image: //' | sort -u >> "$OUTPUT_FILE"
done < "$HELM_FILE"

sort -u -o "$OUTPUT_FILE" "$OUTPUT_FILE"
