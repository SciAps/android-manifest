# Emulator Setup

## adb
You'll need adb to emulate an analyzer.
* For Windows users, read [this](https://github.com/SciAps/android-manifest/blob/master/docs/windows_adb_setup.md) if you do not have adb.
* For Linux/macOS users, adb gets installed as part of [setting up the development environment](https://github.com/SciAps/DART-SD410-manifest/blob/master/README.md).

## XRF
1. Download and Install VirtualBox: https://www.virtualbox.org/wiki/Downloads
2. Download and Install Genymotion: https://www.genymotion.com/download/
3. Download the ARM translation kit: https://s3-us-west-2.amazonaws.com/sciaps-dev/Genymotion-ARM-Translation_v1.1.zip
4. Launch Genymotion and scroll all the way to the bottom of the device template list
5. Click on **ADD CUSTOM DEVICE** and type **XRF-17** for the name. Use the following props:
  * Display Size of 480x800 | 213 - TVDPI
  * Android version: 4.2
  * Processor(s): 2
  * Memory size: 1024
6. Click **Install**
7. Once the emulator has finished installing, simply double-click to start
8. Drag'n'Drop the Genymotion-ARM-Translation_v1.1.zip into your Emulator window, click OK at the prompt to flash
9. Restart the Emulator
10. With your emulator running, plug in an XRF analyzer
11. On the XRF analyzer, open a Testing App that you would like to emulate (e.g. Alloy)
12. Perform an Energy Calibration
13. Place a sample in the XRF Test Stand
14. In the 3 dot menu, click **Save Spectra**; enter name of the sample; take test
15. Repeat steps 13-14 as many times as needed, all spectra will be saved to /sdcard/sciaps/spectra/
16. When ready, run the **emulate_xrf_analyzer** script (see ../scripts/<windows|posix>/)
17. Your analyzer is now emulated
