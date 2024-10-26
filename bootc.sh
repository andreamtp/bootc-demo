 #!/bin/bash

source demo.sh/demo.sh

# Check if two parameters are passed
if [ "$#" -ne 2 ]; then
  echo "Error: Two parameters are required."
  echo "Usage: $0 [f40 | cs9] [qcow2 | iso | ks]"
  exit 1
fi

# Validate the first parameter (f40 or cs9)
if [[ "$1" != "f40" && "$1" != "cs9" ]]; then
  echo "Error: The first parameter must be either 'f40' or 'cs9'."
  exit 1
fi

# Validate the second parameter (qcow2, iso, or ks)
if [[ "$2" != "qcow2" && "$2" != "iso" && "$2" != "ks" ]]; then
  echo "Error: The second parameter must be 'qcow2', 'iso', or 'ks'."
  exit 1
fi

DISTRO=$1
TARGET=$2
TYPE=$2

if [[ "$2" == "qcow2" ]]; then
    OUTPUTDIR=${DISTRO}/$TARGET
else
    OUTPUTDIR=${DISTRO}/bootiso
    TYPE=anaconda-iso
fi

CONTAINERFILE=${DISTRO}/${DISTRO}.container
IMAGE_BUILDER_CONF=config/${TARGET}.toml
REGISTRY=quay.io/aperotti
REPO=${REGISTRY}/${DISTRO}-bootc
TAG=linuxday
IMAGE=${REPO}:$TAG


ps1() {
#    echo -ne "\$ \033[00m"
     echo -ne "\$ "
}

clear

DEMO_NOWAIT=yes
DEMO_CSIZE=1
#DEMO_SPEED=0.1
DEMO_AUTO_TYPE=yes

# p  : prints something without executing nothing
# pi : command is like 'p' but prints the whole line
# pe : print and executed

### pe 'sudo dnf5 install podman'

pei "bat -n $CONTAINERFILE"
echo ""
pause

pei "podman build -f $CONTAINERFILE -t $IMAGE ."
echo ""
pause
# we want to have this container avail also for root user
podman image scp $(whoami)@localhost::$IMAGE
clear
##pei "podman push localhost/$TAG $REPO"
##sudo podman pull $REPO
##pause
##clear
pei "bat -n $IMAGE_BUILDER_CONF"
echo ""
pause

echo "sudo podman run
--rm
-it
--privileged
--pull=newer
--security-opt label=type:unconfined_t
-v $(pwd)/${DISTRO}:/output
-v $(pwd)/$IMAGE_BUILDER_CONF:/config.toml:ro
-v /var/lib/containers/storage:/var/lib/containers/storage
quay.io/centos-bootc/bootc-image-builder:latest
--type $TYPE
--rootfs xfs
--local
$IMAGE" | highlight -S sh -O ansi
echo ""
pause

sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/${DISTRO}:/output \
    -v $(pwd)/$IMAGE_BUILDER_CONF:/config.toml:ro \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type $TYPE \
    --rootfs xfs \
    --local \
    $IMAGE

pei "ls -lsah $OUTPUTDIR"

pause
clear
