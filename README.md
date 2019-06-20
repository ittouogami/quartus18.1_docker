Quartus Prime Lite Edition docker image
====

#Overview

## Description
Quartus Prime enviroment on Ubuntu.

## Requirement
* Quartus Prime Lite のフルインストーラー、及びアップデータをネットワーク参照できる場所に置く。
* URIは環境に合わせてDockerfileを変更する(環境変数URIS)。
* Docker上のユーザ/グループは、ホストの1000:1000と共通とする。
* HOMEをホストの$HOME/docker/userhomeに固定としてmountする。
* $HOME/docker/userhome/.bashrcに下記を設定しておく。 
```
alias quartus='env SWT_GTK3=0 quartus'
``` 
* ホスト上で予めUSBブラスターを認識させておく。
```
$cat /etc/udev/rules.d/99-alterablaster.rules
# Intel/Altera USB-Blaster
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666", SYMLINK+="usbblaster/%k"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666", SYMLINK+="usbblaster/%k"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666", SYMLINK+="usbblaster/%k"
# Intel/Altera USB-Blaster II
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666", SYMLINK+="usbblaster2/%k"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666", SYMLINK+="usbblaster2/%k"
```
* 公式とは別にカスタムのUbuntu16イメージをベースにしているので、別途準備する。
https://github.com/ittouogami/ubuntu16_docker

## Install

```
$./build.sh
$./boot.sh
```

## Author

[ittou](https://github.com/ittouogami)


