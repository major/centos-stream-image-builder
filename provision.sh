#!/bin/bash

echo "fastestmirror=1" >> /etc/dnf/dnf.conf
dnf -y upgrade
dnf -y install composer-cli osbuild-composer jq
usermod -a -G weldr vagrant
systemctl enable --now osbuild-composer.socket
for i in `seq 1 10`; do
    composer-cli status show && break
    sleep 1
done