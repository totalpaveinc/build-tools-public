
##############
# Asserts the runtime for mac / darwin runtime.
# Kills the bash program otherwise.
#
# Usage: assertMac
# 
##############
function assertMac {
    if [ `uname` != "Darwin" ]; then
        echo "Mac is required for publishing"
        exit 1
    fi
}

##############
# Asserts that the current path is inside a Git repo.
# Kills the bash program otherwise.
#
# Usage: assertGitRepo
# 
##############
function assertGitRepo {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Not in a Git repository."
        exit 1
    fi
}

##############
# Asserts that the Git repo is clean.
# Kills the bash program otherwise.
#
# Usage: assertCleanRepo
# 
##############
function assertCleanRepo {
    if ! git diff-index --quiet HEAD --; then
        echo "Git repository is not clean. There are uncommitted changes."
        exit 1
    fi
}
