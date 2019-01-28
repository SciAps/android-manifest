#!/bin/bash

echo 'Remounting file system with write access...'
adb -e shell mount -o rw,remount /
adb -e shell mount -o rw,remount /system

echo 'Force stopping XRF apps...'
adb -e shell am force-stop com.sciaps.phenix
adb -e shell am force-stop com.sciaps.xrf

work_dir=$(mktemp -d)
echo 'Work Dir: $work_dir'

pushd $work_dir

echo 'Pulling Apps...'
XRFAndroidApkFileName=$(adb -d shell ls /data/app/com.sciaps.xrf* | xargs -n 1 basename | tr -d '\r')
XRFHomeApkFileName=$(adb -d shell ls /data/app/com.sciaps.android.home* | xargs -n 1 basename | tr -d '\r')
adb -d pull /data/app/$XRFAndroidApkFileName
adb -d pull /data/app/$XRFHomeApkFileName

echo 'Pulling Emulator Support Files...'
adb -d pull /sdcard/sciaps
adb -d pull /data/data/com.sciaps.xrf/shared_prefs
adb -d pull /storage/extsdcard/db
adb -d pull /storage/extsdcard/ecal.log
adb -d pull /storage/extsdcard/pin.cfg

echo "Installing XRFAndroid..."
adb -e shell rm -rf /data/data/com.sciaps.xrf
adb -e push $XRFAndroidApkFileName /data/local/tmp/app.apk
adb -e shell chmod 777 "/data/local/tmp/app.apk"
adb -e shell pm install -d -r "/data/local/tmp/app.apk"

echo "Installing XRFHome..."
adb -e shell rm -rf /data/data/com.sciaps.android.home
adb -e push $XRFHomeApkFileName /data/local/tmp/app.apk
adb -e shell chmod 777 "/data/local/tmp/app.apk"
adb -e shell pm install -d -r "/data/local/tmp/app.apk"

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
adb -e shell am start com.sciaps.android.home/.HomeActivity
