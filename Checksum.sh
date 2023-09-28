

function sha1_compute {
    echo "$(shasum -a 1 $1  | cut -d ' ' -f 1)"
}
