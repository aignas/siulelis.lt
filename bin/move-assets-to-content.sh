#!/bin/bash
set -euo pipefail

readonly git_root=$(git rev-parse --show-toplevel)
readonly path_c="hugo/content/galerija"
readonly path_a="hugo/assets/img/gallery"

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
    for folder in "${git_root}/${path_a}"/*; do
        name="$(basename "$folder")"
        content="${git_root}/${path_c}/$name"
        [[ -d "$content" ]] || die "did not find content dir in content/galerija"
        echo -n "$name "
        git mv "$folder"/*.jpg "$content"/
    done
    _done
    change_git_attributes "${path_a}" "${path_c}"
}

to_assets() {
    echo "moving images back to assets..."
    for folder in "${git_root}/${path_c}"/*; do
        name="$(basename "$folder")"
        assets="${git_root}/${path_a}/$name"
        mkdir -p "$assets"
        echo -n "$name "
        git mv "$folder"/*.jpg "$assets"/
    done
    _done
    change_git_attributes "${path_c}" "${path_a}"
}

change_git_attributes() {
    echo "changing git attributes for LFS to track $2"
    sed -i "s|$1|$2|" "${git_root}/.gitattributes"
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
