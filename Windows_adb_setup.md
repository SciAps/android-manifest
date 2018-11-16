# Windows 10 adb Setup

The simplest instructions you'll ever read for anything ever

Before we get started, make sure your Android device is NOT plugged in

### Download and Install Android Studio
1. Open your web browser and navigate to https://developer.android.com/studio/index.html
2. Click the *DOWNLOAD ANDROID STUDIO* button
3. Check the *I have read and agree with the above terms and conditions* box
4. Click the *DOWNLOAD ANDROID STUDIO FOR WINDOWS* button
5. When prompted, click *Save*
6. Once the download completes, go to your Downloads folder and double-click the file (e.g. *android-studio-ide-181.5056338-windows.exe* as of this writing)
7. In the *Android Studio Setup* window, just keep clicking *Next*
8. Once the Install completes, click *Next* and then *Finish*, Android Studio will start up.
9. If you see the *Complete Installation* window, make sure to leave the "Do not import settings" radio button selected; click *OK*
10. In the *Android Studio Setup Wizard* window, just keep clicking *Next*
11. Once all of the files have finished unzipping, Click *Finish*
12. In the *Welcome to Android Studio* window, click *Configure* in the bottom-right corner
13. Click *SDK Manager*
14. Switch to the *SDK Tools* tab
15. Check the *Google USB Driver* box
16. Click *Apply* in the bottom-right corner; *OK*
17. *Accept* the license; click *Next*
18. Once the Install is complete, click *Finish*
19. Click the *OK* button to close the *Default Settings* window
20. Close the *Welcome to Android Studio* window
21. Open *File Explorer*
22. Right-click on *This PC*, click *Properties*
23. Click *Advanced system settings*
24. Click *Environment Variables...*
25. In the bottom box labeled *System variables*, double-click the row named for Variable *Path*
26. Click *New* in the top-right corner
27. Paste the following: *C:\Users\sgowen\AppData\Local\Android\Sdk\platform-tools*, but be sure to change *sgowen* to your username.
  1. If you don't know what your username is, just open *File Explorer* again and check your *C:\Users* directory, there should be at least 2 folders, one of which is your username
28. Once you've added the path, keep clicking *OK* until all of the windows are closed.
29. Click into the text box in the bottom-left corner of your PC (next to the classic Windows logo)
30. Type *cmd* and then hit the *Enter* key on your keyboard
31. At this point, plug in your Android device (Windows should automatically set up the device properly since you installed the *Google USB Driver* earlier)
32. In the *Command Prompt* window, type *adb shell* and hit the *Enter* key again
33. The adb server will start and then you will be connected to the device; type *ls* to view the root filesystem.
  1. If you the message: *error: no devices/emulators found*, try unplugging the usb cable and plug it back in.
  2. If you are still seeing the message, then it's possible that your Windows OS has already configured an Android device driver before (before you followed this guide probably), and therefore Windows is NOT using the *Google USB Driver*, but rather a generic USB driver. If this is the case, see John Egan for instructions on how to reconfigure your Android Device USB Driver.
