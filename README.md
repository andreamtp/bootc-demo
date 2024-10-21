# DEMO for bootc

This repo contains all you may need to demo Linux Bootable Container technology.

Three scenarios are described:
1) creation of a QCOW2 image
2) creation of an unattended installation ISO image
3) creation of an unattended installation ISO image with custom kickstart 

High level steps needed:
* create containterfile from a `bootc` enabled base image
* build the containterfile
* (optional) push the image to a container registry
* build the OS file image (QCOW2) or an ISO installation media, with the help of a config file
* provision an virtual system and deploy the OS according to the created media
* login and verify that customization specified in the containerfile and in the config file are applied (limitations applies)
* **bonus steps**
* update the containterfile 
* build a new release with the same tag
* run `bootc update` and reboot to see changes applied

Feel free to take inspiration to the [Fedora Bootc Examples repo](https://gitlab.com/fedora/bootc/examples/-/tree/main/) on meaningful OS configuration examples that may be useful for your audience.


NOTE: Option 2 does not allow to customize via config file or cli the localization of the system.

Reference documentation:
https://osbuild.org/docs/user-guide/blueprint-reference/
