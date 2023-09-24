
##############
# Syncs a gradle project to a specific wrapper version.
# Will use /GRADLE_VERSION file if a version is not specified
#
# Usage: syncGradle <projectPath> [gradleVersion]
# 
##############
function syncGradle() {
    local gradleProject="$1"
    local gradleVersion=$(echo -n $2)

    if [ "$gradleVersion" == "" ]; then
        gradleVersion=$(echo $(cat GRADLE_VERSION))
    fi

    echo "Syncing Gradle to $gradleVersion"

    echo -n $gradleVersion > GRADLE_VERSION

    pushd $gradleProject
    if [ -e gradlew ]; then
        ./gradlew wrapper --gradle-version $gradleVersion
    else
        gradle wrapper --gradle-version $gradleVersion
    fi
    popd
}
