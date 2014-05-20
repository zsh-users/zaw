if [ `cat /etc/group | grep docker | grep $USER` ]; then
    DOCKER_CMD="docker"
else
    DOCKER_CMD="sudo docker"
fi

function zaw-src-docker-images() {
    desc=`$DOCKER_CMD images 2>/dev/null | awk 'NR!=1{printf"%s/%s [%s] (%s %s %s)\n", $1, $2, $3, $4, $5, $6}'`
    cand=`echo $desc | sed `

    : ${(A)cand_descriptions::=${(f)desc}}
    : ${(A)candidates::=${(f)desc}}
    actions=(
        zaw-docker-run \
        zaw-docker-history \
        zaw-docker-rmi \
        zaw-docker-append-to-buffer
    )
    act_descriptions=(
        "run" \
        "history" \
        "remove this image" \
        "append to edit buffer"
    )
    options=()
}

function _zaw-docker-image-id(){
   echo $1 | sed -e 's/^.*\[\(.*\)].*$/\1/'
}

function zaw-docker-append-to-buffer(){
    IMAGE_ID=`_zaw-docker-image-id $1`
    zaw-callback-append-to-buffer $IMAGE_ID
}

function zaw-docker-run(){
    IMAGE_ID=`_zaw-docker-image-id $1`
    BUFFER="$DOCKER_CMD run -t -i $IMAGE_ID /bin/bash"
    zle accept-line
}

function zaw-docker-history(){
    IMAGE_ID=`_zaw-docker-image-id $1`
    BUFFER="$DOCKER_CMD history $IMAGE_ID"
    zle accept-line
}

function zaw-docker-rmi(){
    IMAGE_ID=`_zaw-docker-image-id $1`
    BUFFER="$DOCKER_CMD rmi $IMAGE_ID"
    zle accept-line
}

zaw-register-src -n docker-images zaw-src-docker-images
