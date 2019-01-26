#!/bin/bash

ECHO Remounting file system with write access...
adb -e shell mount -o rw,remount /
adb -e shell mount -o rw,remount /system

ECHO Force stopping XRF apps...
adb -e shell am force-stop com.sciaps.phenix
adb -e shell am force-stop com.sciaps.xrf

set work_dir="load_emulation_package"
RMDIR /S %work_dir%
mkdir %work_dir%
pushd %work_dir%

ECHO Pulling Emulator Support Files...
adb -d shell ls /data/app/com.sciaps.xrf* | xargs -n 1 basename > XRFAndroidApkFileName.txt
set /p XRFAndroidApkFileName=<XRFAndroidApkFileName.txt
adb -d shell ls /data/app/com.sciaps.android.home* | xargs -n 1 basename > XRFHomeApkFileName.txt
set /p XRFHomeApkFileName=<XRFHomeApkFileName.txt
adb -d pull /data/app/%XRFAndroidApkFileName%
adb -d pull /data/app/%XRFHomeApkFileName%
adb -d pull /sdcard/sciaps
adb -d pull /data/data/com.sciaps.xrf/shared_prefs
adb -d pull /storage/extsdcard/db
adb -d pull /storage/extsdcard/ecal.log
adb -d pull /storage/extsdcard/pin.cfg

ECHO Installing Emulator Support Files...
adb -e shell rm -rf /sdcard/sciaps
adb -e shell rm -rf /data/data/com.sciaps.xrf/shared_prefs
adb -e shell rm -rf /sdcard/emulator

adb -e shell mkdir /sdcard/emulator

ECHO Installing XRFAndroid
adb -e push %XRFAndroidApkFileName% /data/local/tmp/app.apk
adb -e shell chmod 777 "/data/local/tmp/app.apk"
adb -e shell pm install -d -r "/data/local/tmp/app.apk"

ECHO Installing XRFHome
adb -e push %XRFHomeApkFileName% /data/local/tmp/app.apk
adb -e shell chmod 777 "/data/local/tmp/app.apk"
adb -e shell pm install -d -r "/data/local/tmp/app.apk"

adb -e push sciaps /sdcard/sciaps
adb -e push shared_prefs /data/data/com.sciaps.xrf/shared_prefs
adb -e push db /sdcard/emulator/db
adb -e push ecal.log /sdcard/emulator/ecal.log
adb -e push pin.cfg /sdcard/emulator/pin.cfg

popd
rm -rf %work_dir%

ECHO Force stopping XRF Home...
adb -e shell am force-stop com.sciaps.android.home