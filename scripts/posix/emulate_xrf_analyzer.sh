#!/bin/bash

echo 'Restarting adb with sudo rights...'
adb kill-server
sudo adb start-server

echo 'Remounting file system with write access...'
adb -e shell mount -o rw,remount /
adb -e shell mount -o rw,remount /system

echo 'Force stopping XRF apps...'
adb -e shell am force-stop com.sciaps.phenix
adb -e shell am force-stop com.sciaps.xrf

work_dir=$(mktemp -d)

pushd $work_dir

echo 'Pulling Emulator Support Files...'
adb -d pull /sdcard/sciaps
adb -d pull /data/data/com.sciaps.xrf/shared_prefs
adb -d pull /storage/extsdcard/db
adb -d pull /storage/extsdcard/ecal.log
adb -d pull /storage/extsdcard/pin.cfg

echo 'Installing Emulator Support Files...'
adb -e shell rm -rf /sdcard/sciaps
adb -e shell rm -rf /data/data/com.sciaps.xrf/shared_prefs
adb -e shell rm -rf /sdcard/emulator

adb -e shell mkdir /sdcard/emulator

adb -e push sciaps /sdcard/sciaps
adb -e push shared_prefs /data/data/com.sciaps.xrf/shared_prefs
adb -e push db /sdcard/emulator/db
adb -e push ecal.log /sdcard/emulator/ecal.log
adb -e push pin.cfg /sdcard/emulator/pin.cfg

popd
rm -rf $work_dir

echo 'Force stopping XRF Home...'
adb -e shell am force-stop com.sciaps.android.home
