
source build-tools/public/DirectoryTools.sh
source build-tools/public/assertions.sh

function SyncModules {
    git submodule update --recursive --init
    git submodule update --recursive
}

# Usage:
# SyncDepFromGitHub <repo-owner> <repo-name> <version> <filename>
function SyncDepFromGitHub {
    # https://github.com/totalpaveinc/sqlite/releases/tag/v0.1.0
    local depOwner="$1"
    local depPackage="$2"
    local depVersion="$3"
    local depFile="$4"

    local shouldDownload="0"

    local URL="https://github.com/$depOwner/$depPackage/releases/download/$depVersion/$depFile"

    EXPECTED_CHECK=$(curl -sSL "$URL.sha1.txt")
    assertLastCall
    EXPECTED_CHECK="$(echo -e "${EXPECTED_CHECK}" | sed -E -e 's/^[[:space:]]+//' -e 's/[[:space:]]+$//')"
    assertLastCall

    if [ -s "deps/.$depFile" ]; then
        CURRENT_CHECKSUM=$(echo -n deps/.$depFile)
        assertLastCall
        if [ "$CURRENT_CHECK" != "$EXPECTED_CHECK" ]; then
            shouldDownload="1"
        fi
    else
        shouldDownload="1"
    fi

    if [ "$shouldDownload" == "0" ]; then
        return
    fi

    echo $URL
    echo $depPackage
    echo $depFile

    local depFolder="deps/$depPackage/${depPackage}_${depFile}"

    rm -rf "deps/$depPackage/$depPackage-$depFile"
    rm -f "deps/.$depFile"

    mkdir -p $depFolder

    curl -L -o "$depFolder/$depFile" "$URL"
    assertLastCall

    if [[ $depFile == *.zip ]]; then
        spushd $depFolder
            unzip $depFile
            assertLastCall
            rm -f $depFile
        spopd
    fi

    echo -n $EXPECTED_CHECK > deps/.$depFile
}
