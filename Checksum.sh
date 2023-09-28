

function sha1_compute {
    echo -n "$(shasum -a 1 $1  | cut -d ' ' -f 1)" > $1.sha1.txt
}
