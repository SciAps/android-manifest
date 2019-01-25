# Emulator Setup

### XRF
1. Download/Install VirtualBox: https://www.virtualbox.org/wiki/Downloads
2. Download/Install Genymotion: https://www.genymotion.com/download/
3. Download the ARM translation kit: https://s3-us-west-2.amazonaws.com/sciaps-dev/Genymotion-ARM-Translation_v1.1.zip
4. Create Emulator named XRF 17 with the following props:
  * Display Size of 480x800 | 213 - TVDPI
  * Android version: 4.2
  * Processor(s): 2
  * Memory size: 1024
5. Start up your emulator
6. Drag'n'Drop the Genymotion-ARM-Translation_v1.1.zip into your Emulator window, click OK at the flash prompt
7. Restart the Emulator using the Genymotion app 3-dot menu (stop and then start)
8. Install XRFAndroid and XRFHome
9. With your emulator running, plug in an XRF analyzer
10. Open an app that you would like to emulate
11. Click on the **Save Spectra** menu option in the 3 dot menu and type "ecal"
12. Perform an Energy Calibration
13. After Energy Calibration, repeat step 11 as often as you like, except type in the name of samples you are analzying
14. On the Desktop side, run the **emulate_xrf_analyzer** script (see https://github.com/SciAps/android-manifest/tree/master/scripts)
15. Your emulator now emulates your analyzer
