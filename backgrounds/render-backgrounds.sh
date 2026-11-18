#!/usr/bin/env bash

# Define paths to the necessary tools
INKSCAPE="/run/current-system/sw/bin/inkscape"
OPTIPNG="/run/current-system/sw/bin/optipng"

# Get the directory of the current script
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Define variants for themes, types, sides, and colors
THEME_VARIANTS=('-yerba-buena' '-fog' '-580W' '-golden-gate')
TYPE_VARIANTS=('-window' '-float' '-sharp' '-blur')
SIDE_VARIANTS=('-left' '-right')
COLOR_VARIANTS=('-dark')

# Function to render background images for each combination of theme, type, side, and color
# Arguments:
#   theme - Theme variant (e.g., -yerba-buena, -fog)
#   type - Type variant (e.g., -window, -float)
#   side - Side variant (e.g., -left, -right)
#   color - Color variant (e.g., -dark)
render_background() {
    local theme="${1}"
    local type="${2}"
    local side="${3}"
    local color="${4}"
    
    local FILEID="background${theme}${type}${side}${color}"
    local FILENAME="$REPO_DIR/backgrounds${theme}/$FILEID"
    
    # Create the backgrounds directory for the theme if it doesn't exist
    mkdir -p "$REPO_DIR/backgrounds${theme}"
    
    # Check if the JPEG file already exists
    if [[ -f "$FILENAME.jpg" ]]; then
        echo "$FILENAME exists"
    else
        echo -e "\nRendering $FILENAME.png"
        # Export the SVG to PNG using Inkscape
        $INKSCAPE "--export-id=$FILEID" \
        "--export-dpi=96" \
        "--export-id-only" \
        "--export-filename=$FILENAME.png" "backgrounds${theme}.svg" >/dev/null
        # Convert the PNG to JPEG using ImageMagick
        magick "$FILENAME.png" "$FILENAME.jpg"
    fi
    
    # Remove the temporary PNG file
    rm -rf "$FILENAME.png"
}

# Iterate over all combinations of theme, type, side, and color variants
for theme in "${THEME_VARIANTS[@]}"; do
    for type in "${TYPE_VARIANTS[@]}"; do
        for side in "${SIDE_VARIANTS[@]}"; do
            for color in "${COLOR_VARIANTS[@]}"; do
                render_background "${theme}" "${type}" "${side}" "${color}"
            done
        done
    done
done

exit 0
