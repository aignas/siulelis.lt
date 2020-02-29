#!/bin/bash
set -euo pipefail

readonly git_root=$(git rev-parse --show-toplevel)
readonly path_c="$git_root/hugo/content/galerija"
readonly path_a="$git_root/hugo/assets/img/gallery"

die() {
    echo "$@"
    exit 1
}

_done() {
    echo ""
    echo "DONE"
    echo ""
}

to_content() {
    echo "moving images to content..."
    for folder in "${path_a}"/*; do
        name="$(basename "$folder")"
        content="${path_c}/$name"
        [[ -d "$content" ]] || die "did not find content dir in content/galerija"
        echo -n "$name "
        git mv "$folder"/*.jpg "$content"/
    done
    _done
}

to_assets() {
    echo "moving images back to assets..."
    for folder in "${path_c}"/*; do
        name="$(basename "$folder")"
        assets="${path_a}/$name"
        mkdir -p "$assets"
        echo -n "$name "
        git mv "$folder"/*.jpg "$assets"/
    done
    _done
}

main() {
    case "${1-test}" in
    --to-content)
        to_content
        ;;
    --to-assets)
        to_assets
        ;;
    test)
        to_content
        to_assets
        ;;
    *)
        die "unknown argument $1"
        ;;
    esac
}

main "$@"
