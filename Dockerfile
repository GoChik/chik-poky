FROM crops/yocto:ubuntu-19.04-base

USER root

RUN sudo apt update \
 && sudo apt install -y vim git wget \
 && apt-get clean

USER yoctouser
