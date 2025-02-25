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

# Default values
DOWNLOAD_DIR="${HOME}/download"
INSTALL_DIR="/usr/local"

ARCH="amd64"
OS="linux"

KEEP_ARCHIVE=false
FORCE=false
CLEANUP_OLD=false
VERBOSE=false

# Function to print usage
usage() {
    echo "Usage: $0 [options] <version>"
    echo "Options:"
    echo "  -d <dir>    Specify download directory (default: ${HOME}/download)"
    echo "  -i <dir>    Specify installation directory (default: /usr/local)"
    echo "  -a <arch>   Specify architecture (default: amd64)"
    echo "  -o <os>     Specify operating system (default: linux)"
    # echo "  -k          Keep downloaded archive"
    # echo "  -f          Force reinstallation"
    # echo "  -c          Cleanup old versions"
    # echo "  -v          Verbose mode"
    echo "  -h          Show this help message"
    exit 1
}

# Parse command line options
while getopts "d:i:a:o:kfcvnh" opt; do
    case ${opt} in
        d )
            DOWNLOAD_DIR=$OPTARG
            ;;
        i )
            INSTALL_DIR=$OPTARG
            ;;
        a )
            ARCH=$OPTARG
            ;;
        o )
            OS=$OPTARG
            ;;
        k )
            KEEP_ARCHIVE=true
            ;;
        f )
            FORCE=true
            ;;
        c )
            CLEANUP_OLD=true
            ;;
        v )
            VERBOSE=true
            ;;
        h )
            usage
            ;;
        \? )
            usage
            ;;
    esac
done
shift $((OPTIND -1))


# Check if version is provided
if [ $# -eq 0 ]; then
    echo "Error: Version number is required."
    usage
fi


VERSION="$1"

# Input validation
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echoerr "Invalid version format. Expected format: X.Y.Z (e.g., 1.22.4)"
    exit 1
fi


SOURCE_FILENAME="go${VERSION}.${OS}-${ARCH}.tar.gz"
SOURCE_URL="https://go.dev/dl/${SOURCE_FILENAME}"

TAR_FILEPATH="${DOWNLOAD_DIR}/${SOURCE_FILENAME}"

DEST_DIR_NAME="go${VERSION}"
DEST_DIR_PATH="${INSTALL_DIR}/${DEST_DIR_NAME}"

SYMBOLIC_LINK_PATH="${INSTALL_DIR}/go"


echo -e "Checking download directory \t'${DOWNLOAD_DIR}'"
if [ ! -e "${DOWNLOAD_DIR}" ]; then
    echo -e "Creating download directory \t'${DOWNLOAD_DIR}'"
    if ! mkdir -p "${DOWNLOAD_DIR}"; then
        echoerr "Failed to create directory '${DOWNLOAD_DIR}'"
        exit 1
    fi
else
    if [ ! -d "${DOWNLOAD_DIR}" ]; then
        echoerr "Download directoy '${DOWNLOAD_DIR}' exists but is not a directory"
        exit 1
    fi
fi

echo -e "Checking destination directory \t'${DEST_DIR_PATH}'"
if [ -d "${DEST_DIR_PATH}" ]; then
    echogreen "Go version '${VERSION}' already installed at '${DEST_DIR_PATH}'"
else
    echo -e "Checking if already downloaded \t'${TAR_FILEPATH}'"
    if [ -f "${TAR_FILEPATH}" ]; then
        echogreen "Tar file '${TAR_FILEPATH}' already downloaded"
    else
        echo -e "Download source file \t\t'${SOURCE_URL}'"
        if ! wget -q --spider "${SOURCE_URL}"; then
            echoerr "URL does not exist '${SOURCE_URL}'"
            exit 1
        fi
        
        wget -q --show-progress "${SOURCE_URL}" -P "${DOWNLOAD_DIR}" || { echoerr "Failed to download source file '${SOURCE_URL}'"; exit 1; }
    fi
    
    echo -e "Creating destination directory \t'${DEST_DIR_PATH}'"
    if ! mkdir -p "${DEST_DIR_PATH}"; then
        echoerr "Failed to create directory '${DEST_DIR_PATH}'"
        exit 1
    fi
    
    echo -e "Untaring the file \t\t'${TAR_FILEPATH}' to '${DEST_DIR_PATH}'"
    if ! tar zxf ${TAR_FILEPATH} -C "${DEST_DIR_PATH}" --strip-components 1; then
        echoerr "Failed to extract tar file '${TAR_FILEPATH}'"
        exit 1
    fi
fi


echo -e "Checking symbolic link exists \t'${SYMBOLIC_LINK_PATH}' exists"
if [ -e "${SYMBOLIC_LINK_PATH}" ]; then
    if [ ! -L "${SYMBOLIC_LINK_PATH}" ]; then
        echoerr "Path '${SYMBOLIC_LINK_PATH}' already exists and is not a symbolic link"
        exit 1
    fi
    
    echo -e "Checking symbolic link target \t'${SYMBOLIC_LINK_PATH}' points to '${DEST_DIR_NAME}'"
    SYMLINK_DESTINATION=$(readlink "$SYMBOLIC_LINK_PATH")
    
    if [ "${SYMLINK_DESTINATION}" != "${DEST_DIR_NAME}" ]; then
        echo -e "Removing old symbolic link \t'${SYMBOLIC_LINK_PATH}' -> '${SYMLINK_DESTINATION}'"
        if ! rm "${SYMBOLIC_LINK_PATH}"; then
            echoerr "Failed to remove existing symbolic link '${SYMBOLIC_LINK_PATH}'"
            exit 1
        fi
    else
        echogreen "Symbolic link '${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}' already exists"
        cd "${INSTALL_DIR}"
        ls -d1 go* | tail -n +2
        echogreen "Success. Done."
        exit 0
    fi
fi

echo -e "Changing working directory to \t'${INSTALL_DIR}'"
cd "${INSTALL_DIR}"

echo -e "Creating new symbolic link \t'${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}'"
if ! ln -sf "${DEST_DIR_NAME}" "$(basename "${SYMBOLIC_LINK_PATH}")"; then
    echoerr "Failed to create symbolic link '${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}'"
    exit 1
fi

echogreen "Symbolic link '${SYMBOLIC_LINK_PATH}' -> '${DEST_DIR_NAME}' Created"

ls -d1 go* | tail -n +2

echogreen "Success. Done."
exit 0
