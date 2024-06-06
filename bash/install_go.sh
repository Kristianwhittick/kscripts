#!/bin/bash
#
# download new version of from https://go.dev/dl/ to the tmp folder
# example go1.22.4.linux-amd64.tar.gz
# extra the tar to /usr/local/XXX
# replace the symbolic link

echogreen() {
    printf "\033[0;32m%s\033[0m\n" "$*"
}

echoerr() {
    printf "\033[0;31mError: %s\n\033[0m" "$*" >&2
}

if [ "$(id -u)" -ne 0 ]; then
    echoerr "This script must be run as root"
    exit 1
fi

if [[ -z "$1" || ${#1} -le 5 ]]; then
    echoerr "Version is empty or too short"
    exit 1
fi

if [[ $1 == *[[:space:]]* ]]; then
    echoerr "Version '$1' contains spaces"
    exit 1
fi

readonly VERSION="$1"

readonly SOURCE_FILENAME="go${VERSION}.linux-amd64.tar.gz"
readonly SOURCE_URL="https://go.dev/dl/${SOURCE_FILENAME}"

readonly DOWNLOAD_PATH="${HOME}/download"
readonly TAR_FILEPATH="${DOWNLOAD_PATH}/${SOURCE_FILENAME}"

readonly DEST_PATH="/usr/local"
readonly DEST_DIR_NAME="go${VERSION}"
readonly DEST_DIR_PATH="${DEST_PATH}/${DEST_DIR_NAME}"

readonly SYMBOLIC_LINK_PATH="${DEST_PATH}/go"


echo "Checking download directory '${DOWNLOAD_PATH}'"
if [ ! -e "${DOWNLOAD_PATH}" ]; then
    echo "Creating download directory '${DOWNLOAD_PATH}'"
    if ! mkdir -p "${DOWNLOAD_PATH}"; then
        echoerr "Failed to create directory '${DOWNLOAD_PATH}'"
        exit 1
    fi
else
    if [ ! -d "${DOWNLOAD_PATH}" ]; then
        echoerr "Download directoy '${DOWNLOAD_PATH}' exists but is not a directory"
        exit 1
    fi
fi

echo "Checking destination directory '${DEST_DIR_PATH}'"
if [ -d "${DEST_DIR_PATH}" ]; then
    echogreen "Go version '${VERSION}' already installed at '${DEST_DIR_PATH}'"
else
    echo "Checking source file '${TAR_FILEPATH}'"
    if [ -f "${TAR_FILEPATH}" ]; then
        echogreen "Tar file '${TAR_FILEPATH}' already installed"
    else
        echo "Downloading source file '${SOURCE_URL}'"
        if ! wget -q --spider "${SOURCE_URL}"; then
            echoerr "URL does not exist '${SOURCE_URL}'"
            exit 1
        fi

        wget "${SOURCE_URL}" -P "${DOWNLOAD_PATH}" || { echoerr "Failed to download source file '${SOURCE_URL}'"; exit 1; }

        echo "Creating Directory '${DEST_DIR_PATH}'"
        if ! mkdir -p "${DEST_DIR_PATH}"; then
            echoerr "Failed to create directory '${DEST_DIR_PATH}'"
            exit 1
        fi

        echo "Untaring the file '${TAR_FILEPATH}' to '${DEST_DIR_PATH}'"
        if ! tar zxf ${TAR_FILEPATH} -C "${DEST_DIR_PATH}" --strip-components 1; then
            echoerr "Failed to extract tar file '${TAR_FILEPATH}'"
            exit 1
        fi
    fi
fi

echo "Checking symbolic link '${SYMBOLIC_LINK_PATH}' exists"
if [ -e "${SYMBOLIC_LINK_PATH}" ]; then
    if [ ! -L "${SYMBOLIC_LINK_PATH}" ]; then
        echoerr "Path '${SYMBOLIC_LINK_PATH}' already exists and is not a symbolic link"
        exit 1
    fi

    echo "Checking existing symbolic link target '${SYMBOLIC_LINK_PATH}' points to '${DEST_DIR_NAME}'"
    SYMLINK_DESTINATION=$(readlink "$SYMBOLIC_LINK_PATH")

    if [ "${SYMLINK_DESTINATION}" != "${DEST_DIR_NAME}" ]; then
        echo "Removing old existing symbolic link '${SYMBOLIC_LINK_PATH}' -> '${SYMLINK_DESTINATION}'"
        if ! rm "${SYMBOLIC_LINK_PATH}"; then
            echoerr "Failed to remove existing symbolic link '${SYMBOLIC_LINK_PATH}'"
            exit 1
        fi
    else
        echogreen "Symbolic link '${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}' already exists"
        echogreen "Success. Done."
        exit 0
    fi
fi

echo "Changing directory to '${DEST_PATH}'"
cd "$(dirname "${SYMBOLIC_LINK_PATH}")"

echo "Creating symbolic link '${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}'"
if ! ln -sf "${DEST_DIR_NAME}" "$(basename "${SYMBOLIC_LINK_PATH}")"; then
    echoerr "Failed to create symbolic link '${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}'"
    exit 1
fi

echogreen "Success. Done."
exit 0