
source build-tools/public/DirectoryTools.sh
source build-tools/public/assertions.sh

function SyncModules {
    git submodule update --recursive --init
    git submodule update --recursive
}

# Usage:
# gh release download -R totalpaveinc/libtilegen -p tilegen.xcframework.zip.sha1.txt
# SyncDepFromGitHub <repo-owner> <repo-name> <version> <filename>
function SyncDepFromGitHub {
    local depOwner="$1"
    local depPackage="$2"
    local depVersion="$3"
    local depFile="$4"

    local shouldDownload="0"

    EXPECTED_CHECK=$(gh release download -R $depOwner/$depPackage $depVersion -p $depFile.sha1.txt -O -)
    assertLastCall
    # EXPECTED_CHECK="$(echo -e "${EXPECTED_CHECK}" | sed -E -e 's/^[[:space:]]+//' -e 's/[[:space:]]+$//')"

    if [ -s "deps/.$depFile" ]; then
        CURRENT_CHECK="$(cat deps/.$depFile)"
        assertLastCall
        if [ "$CURRENT_CHECK" != "$EXPECTED_CHECK" ]; then
            shouldDownload="1"
        fi
    else
        shouldDownload="1"
    fi

    if [ "$shouldDownload" == "0" ]; then
        echo "Skipping $depPackage... already up to date"
        return
    fi

    echo "Syncing $depPackage..."

    local depFolder="deps/$depPackage/${depPackage}_${depFile}"

    rm -rf "$depFolder"
    rm -f "deps/.$depFile"

    mkdir -p $depFolder

    echo "Downloading $depFile..."
    gh release download -R $depOwner/$depPackage $depVersion -p $depFile -O $depFolder/$depFile
    assertLastCall
    # curl "$GH_TOKEN_PARAMS" -L -o "$depFolder/$depFile" "$URL"
    # assertLastCall

    if [[ $depFile == *.zip ]]; then
        spushd $depFolder
            unzip $depFile
            assertLastCall
            rm -f $depFile
        spopd
    fi

    echo -n $EXPECTED_CHECK > deps/.$depFile
}
