 #!/bin/bash

source demo.sh/demo.sh

CONTAINERFILE=f40.container
TAG=f40-bootc:iso
IMAGE_BUILDER_CONF=config-qcow2.toml

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

pei "podman build -f $CONTAINERFILE -t $TAG ."
echo ""
pause
# we want to have this container avail also for root user
podman image scp $(whoami)@localhost::$TAG
clear
pei "bat -n $IMAGE_BUILDER_CONF"
echo ""
pause

echo "sudo podman run
--rm
-it
--privileged
--pull=newer
--security-opt label=type:unconfined_t
-v $(pwd)/output:/output
-v $(pwd)/$IMAGE_BUILDER_CONF:/config.toml:ro
-v /var/lib/containers/storage:/var/lib/containers/storage
quay.io/centos-bootc/bootc-image-builder:latest
--type qcow2
--rootfs xfs
--local
localhost/$TAG" | highlight -S sh -O ansi
echo ""
pause

sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    -v $(pwd)/$IMAGE_BUILDER_CONF:/config.toml:ro \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 \
    --rootfs xfs \
    --local \
    localhost/$TAG

pei 'ls -lsah output/qcow2/'

# type the command automatically'
# DEMO_AUTO_TYPE=yes

# control the speed of typing with DEMO_CSIZE and DEMO_SPEED'
# slow
# DEMO_CSIZE=1 DEMO_SPEED=0.5

# fast
# DEMO_CSIZE=1 DEMO_SPEED=0.01

# automatically send the command without pressing enter'
# DEMO_NOWAIT=yes

pause
clear
