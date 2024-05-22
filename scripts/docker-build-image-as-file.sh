#!/bin/bash
set -e

function print_help {
    echo -e "Build a Docker image for the Dockerfile in *this* directory.\n"

    echo -e "Use: ./docker-build-image-as-file.sh [desired_image_tag] [host_arch]\n"
}

function random_string {
    echo "$(openssl rand -base64 24 | tr -dc 'a-zA-Z' | head -c 12)"
}

function export_image_to_file {
    local IMAGE_TAG="$1"
    # generate a random file name for the output
    # local EXPORTED_IMAGE_FILE_NAME="$(random_string).tar"
    local EXPORTED_IMAGE_FILE_NAME="$IMAGE_TAG.tar"
    # delete if file of same name already exists
    rm -f "$EXPORTED_IMAGE_FILE_NAME"
    # export the Docker image to a file
    docker save -o "$EXPORTED_IMAGE_FILE_NAME" "$IMAGE_TAG"
    echo "$EXPORTED_IMAGE_FILE_NAME"
}

function parse_script_args {
    if [[ "$#" -ne 2 ]]; then
        echo -e "*** Invalid arguments! ***\n"
        print_help
        exit 22
    fi

    if [[ -n "$1" && -n "$2" ]]; then
        echo "desired_image_tag = $1"
        echo "host_arch = $2"
        IMAGE_TAG="$1"
        HOST_ARCH="$2"
    else
        echo -e "*** Invalid arguments! ***\n"
        print_help
        exit 22
    fi
}

# Parse arguments
parse_script_args "$@"
echo -e "---\n"

# Build the Docker image
docker build --tag "$IMAGE_TAG" --platform linux/"$HOST_ARCH" --build-arg PB_ARCH="$HOST_ARCH" .

# Export the image to file, using random file name
export_image_to_file $IMAGE_TAG
