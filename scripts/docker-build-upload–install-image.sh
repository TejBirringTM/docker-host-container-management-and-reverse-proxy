#!/bin/bash
set -e

function print_help {
    echo -e "Build a Docker image for the Dockerfile in *this* directory,\nand (optionally) install it on a remote docker host.\n"

    echo -e "Use: ./docker-build-upload-install-image.sh [desired_image_tag] [host_arch] [host_address?] [path_on_host?]\n"
}

function random_string {
    echo "$(openssl rand -base64 24 | tr -dc 'a-zA-Z' | head -c 12)"
}

function export_image_to_file {
    local IMAGE_TAG="$1"
    # generate a random file name for the output
    local EXPORTED_IMAGE_FILE_NAME="$(random_string).tar"
    # delete if file of same name already exists
    rm -f "$EXPORTED_IMAGE_FILE_NAME"
    # export the Docker image to a file
    docker save -o "$EXPORTED_IMAGE_FILE_NAME" "$IMAGE_TAG"
    echo "$EXPORTED_IMAGE_FILE_NAME"
}

function parse_script_args {
    if [[ "$#" -gt 4 ]]; then
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
    
    if [[ -n "$3" ]]; then
        echo "host_address = $3"
        HOST_ADDR="$3"
    fi

    if [[ -n "$4" ]]; then
        echo "path_on_host = $4"
        PATH_ON_HOST="$4"
    else
        PATH_ON_HOST="/tmp"
    fi
}

function upload_file_to_remote {
    local FILE_NAME="$1"
    local HOST_ADDR="$2"
    local HOST_PATH="$3"
    rsync --quiet --dirs --compress --human-readable --progress "$FILE_NAME" "$HOST_ADDR:$HOST_PATH/"
    echo "$HOST_PATH/$FILE_NAME"
}

function install_archived_image {
    local HOST_ADDR="$1"
    local FILE_PATH_ON_HOST="$2"
    ssh "$HOST_ADDR" "docker load -i $FILE_PATH_ON_HOST"
}

# Parse arguments
parse_script_args "$@"
echo -e "---\n"

# Build the Docker image
docker build --tag "$IMAGE_TAG" --platform linux/"$HOST_ARCH" --build-arg PB_ARCH="$HOST_ARCH" .

# Export, upload, and install the Docker image to remote, if required
if [[ -n "$HOST_ADDR" ]]; then
    
    # export the image to file, using random file name
    EXPORTED_IMAGE_FILE_NAME="$(export_image_to_file $IMAGE_TAG)"
    echo "Image exported: $EXPORTED_IMAGE_FILE_NAME"

    # upload the file to the host
    FILE_PATH_ON_HOST="$(upload_file_to_remote $EXPORTED_IMAGE_FILE_NAME $HOST_ADDR $PATH_ON_HOST)"
    echo "Image uploaded: $FILE_PATH_ON_HOST"

    # install the image
    install_archived_image "$HOST_ADDR" "$FILE_PATH_ON_HOST"
fi
