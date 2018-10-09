# Emulator Setup

1. Using Android Studio, create an Android-17 ARM emulator
2. Run this script when your emulator boots up in order to access the SD card:
```bash
adb shell "mount -o rw,remount rootfs && chmod 777 /mnt/sdcard"
```
3. Select a step 2 updater from https://github.com/SciAps/XRFMasterSDCard (e.g. X50_Rh.sup)
4. adb push X50_Rh.sup /sdcard/
5. Use the Updater app to execute X50_Rh.sup
