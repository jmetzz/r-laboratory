#!/usr/bin/env bash


function usage {
    echo "$0 [OPTIONS]"
    echo "       -h    shows this message"
    echo "       -b    <Location of Dockerfile> build docker image"
    echo "       -t    <tag> sets docker image tag (Dafault: myrstudio)"
    echo "       -r    <container name> run a docker container base on the image created with -b option"
    echo "       -f    flags to force the docker container run."
    echo "                  If a container with the same name already exists it will be removed"
    echo "                  This flag only applies in conjunction to '-r' option."
    echo "       -s    <container name> start an existing named container"
    echo "                  A container with the given name must exists (obviously)"
    echo
}

function error {
    echo "$2" >&2
    usage
    spock "Read the fu#$%^ manual!"
    exit $1
}


banner() {
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./~/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

function spock(){
banner "${1}"
echo "                \\"
echo "                 \\"
echo "                    :                                 :       "
echo "                  :                                   :       "
echo "                  :  RRVIttIti+==iiii++iii++=;:,       :      "
echo "                  : IBMMMMWWWWMMMMMBXXVVYYIi=;:,        :     "
echo "                  : tBBMMMWWWMMMMMMBXXXVYIti;;;:,,      :     "
echo "                  t YXIXBMMWMMBMBBRXVIi+==;::;::::       ,    "
echo "                 ;t IVYt+=+iIIVMBYi=:,,,=i+=;:::::,      ;;   "
echo "                 YX=YVIt+=,,:=VWBt;::::=,,:::;;;:;:     ;;;   "
echo "                 VMiXRttItIVRBBWRi:.tXXVVYItiIi==;:   ;;;;    "
echo "                 =XIBWMMMBBBMRMBXi;,tXXRRXXXVYYt+;;: ;;;;;    "
echo "                  =iBWWMMBBMBBWBY;;;,YXRRRRXXVIi;;;:;,;;;=    "
echo "                   iXMMMMMWWBMWMY+;=+IXRRXXVYIi;:;;:,,;;=     "
echo "                   iBRBBMMMMYYXV+:,:;+XRXXVIt+;;:;++::;;;     "
echo "                   =MRRRBMMBBYtt;::::;+VXVIi=;;;:;=+;;;;=     "
echo "                    XBRBBBBBMMBRRVItttYYYYt=;;;;;;==:;=       "
echo "                     VRRRRRBRRRRXRVYYIttiti=::;:::=;=         "
echo "                      YRRRRXXVIIYIiitt+++ii=:;:::;==          "
echo "                      +XRRXIIIIYVVI;i+=;=tt=;::::;:;          "
echo "                       tRRXXVYti++==;;;=iYt;:::::,;;          "
echo "                        IXRRXVVVVYYItiitIIi=:::;,::;          "
echo "                         tVXRRRBBRXVYYYIti;::::,::::          "
echo "                          YVYVYYYYYItti+=:,,,,,:::::;         "
echo "                          YRVI+==;;;;;:,,,,,,,:::::::    "
}


BUILD=0
RUN=0
FORCE=0
TAG="myrstudio"
CONTAINER_NAME="myrstudio"

if [[ $# -lt 1 ]]; then
    usage
    exit 0
fi


while getopts ":hfs:r:b:t:" opt; do
    case "${opt}" in
        h)
            usage
            exit 0
            ;;
        b)
            BUILD=1
            DOCKERFILE="${OPTARG}"
            ;;
        t)
            TAG="${OPTARG}"
            ;;
        r)
            RUN=1
            CONTAINER_NAME="${OPTARG}"
            ;;
        s)

            CONTAINER_NAME="${OPTARG}"
            docker start "$CONTAINER_NAME"
            ;;
        f)
            FORCE=1
            ;;
        :)
            error 2 "Option -$OPTARG requires an argument."
            ;;
        \?)
            error 1 "Invalid option: -$OPTARG"
            ;;
    esac
done
# shift $((OPTIND-1))


## START THE DOCKER CONTAINERS ###

function build_image(){
    tag="$1"
    dockerfile="$2"
    docker build -t $tag $dockerfile
    echo
    echo "Docker image created with name '$TAG'"
    echo
}

function spinup_container(){
    tag="$1"
    docker run -d -p 8787:8787 -e ROOT=TRUE -e PASSWORD=guest --name $CONTAINER_NAME $tag
    echo
    banner "You can now access RStudio on your browser http://localhost:8787/ with user 'rstudio' and password 'guest'"
    echo
}

function remove_container(){
    container="$1"
    if [ "$(docker ps -aq -f status=exited -f name=$container)" ]; then
        echo "Removing container '$container'"
        docker remove $container
    fi
}


user_name=$(whoami)
deamon=$(pgrep -u $user_name -f docker | wc -l | tr -d ' ')

[[ $deamon == 0 ]] && echo "Docker daemon is not running" && echo " " && exit 0

[[ $BUILD == 1 ]] && build_image $TAG $DOCKERFILE


if [[ $RUN == 1 ]]; then

    [[ $FORCE == 1 || $BUILD == 1 ]] && remove_container $CONTAINER_NAME && spinup_container $TAG && exit 0


    if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
        echo "Container already exist with the same name."
        echo "User -s to start the container OR -f to force existing container to be removed".
        echo "Otherwise, remove it manually before running this script again."
    fi

    spinup_container $TAG
fi



