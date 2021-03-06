# Configuring Ubuntu 14.04 LTS Dev Environment

### Additional Resources
https://source.android.com/source/requirements

### Download Ubuntu 14.04.5 iso
https://s3.us-east-2.amazonaws.com/sciaps-ubuntu/ubuntu-14.04.5-desktop-amd64.iso

### Preliminary steps for macOS Parallels users only
1. Open the Parallels Control Center and click on the *+* symbol in the top-right corner
2. Select the "Install Windows or another OS from DVD or image file" and click *Continue*
3. Drag the ubuntu 14.04.5 LTS iso into the "Installation Assistant" window and click *Continue*
4. Uncheck "Express Installation"
5. Type in a password and click *Continue*
6. Check the "Customize settings before installation" checkbox and click *Create*
7. In the "Configuration" window, click on the *Hardware* tab
8. Bump up the memory to 4096MB at the minimum if you can
9. Bump up the graphics memory to 512 MB if you can
10. Under "Hard Disk", open the "Advanced Settings" and click on *Properties*
11. Drag the slider to 256-512 GB if you can and click *Apply*
12. Under "Mouse & Keyboard", make sure *Don't optimize for games* is selected
13. Close the "Configuration" window and click *Continue*
14. Once Ubuntu is up and running, install Parallels Tools by clicking on the yellow icon in the top-right corner of the Ubuntu VM window

### Install Necessary Tools via apt-get
```bash
sudo apt-get update \
&& sudo apt-get -y install build-essential libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 git-core gnupg flex bison gperf zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip libswitch-perl default-jre u-boot-tools mtd-utils lzop xorg-dev libopenal-dev libglew-dev libalut-dev xclip python ruby-dev openvpn minicom \
&& sudo apt-get -f install
```

### Download GNU Make 3.82
```bash
cd ~/Downloads/ \
&& rm -rf make-3.82 \
&& wget http://ftp.gnu.org/gnu/make/make-3.82.tar.gz \
&& tar -xvf make-3.82.tar.gz \
&& cd make-3.82 \
&& ./configure \
&& make \
&& sudo make install \
&& cd .. \
&& rm make-3.82.tar.gz \
&& sudo rm /usr/bin/make \
&& sudo mv make-3.82 /usr/bin/make-3.82 \
&& sudo ln -s /usr/bin/make-3.82/make /usr/bin/make
```

### Download Google's Repo Tool
```bash
mkdir ~/bin \
&& curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo \
&& chmod a+x ~/bin/repo
```

### Download flatc
```bash
curl https://s3.amazonaws.com/sciaps/flatc > ~/Downloads/flatc \
&& sudo mv ~/Downloads/flatc /opt/flatc \
&& sudo chmod a+x /opt/flatc
```

### Download gradle.properties file for your root ".gradle" folder
```bash
cd ~/Downloads \
&& wget https://s3.us-east-2.amazonaws.com/sciaps-firmware-dependencies/gradle.properties \
&& mkdir -p ~/.gradle/ \
&& sudo mv ~/Downloads/gradle.properties ~/.gradle/
```

### Download the Java SE Development Kit 6
```bash
cd ~/Downloads \
&& wget https://sciaps-firmware-dependencies.s3.us-east-2.amazonaws.com/java-6-oracle.tar.gz \
&& sudo mkdir -p /usr/lib/jvm \
&& sudo tar xvzf java-6-oracle.tar.gz -C /usr/lib/jvm \
&& rm java-6-oracle.tar.gz \
&& sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-6-oracle/bin/java" 1337 \
&& sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-6-oracle/bin/javac" 1337 \
&& sudo update-alternatives --install "/usr/bin/javadoc" "javadoc" "/usr/lib/jvm/java-6-oracle/bin/javadoc" 1337
```

### Download and Install Android Studio
1. https://developer.android.com/studio/index.html
2. Click the big download button and accept the license
3. When prompted, click "Open with Archive Manager", extract to Downloads folder and then run:
```bash
sudo mv ~/Downloads/android-studio ~/android-studio/
```
4. Run Android Studio:
```bash
~/android-studio/bin/studio.sh &
```
5. In the Android Studio Setup Wizard, click Custom
6. Use Defaults, keep clicking Next
7. On the Welcome to Android Studio screen, click the Configure option at the bottom and open the SDK Manager
8. Inside the "SDK Platforms" tab, uncheck all boxes except for API level *17* under "SDK Platforms"; hit apply
9. Switch to the "SDK Tools" tab and check the boxes for *CMake* (use version 3.6.4) and uncheck all Android SDK Build-Tools versions except *21.1.2* (check Show Package Details to see all the options); hit apply (do NOT install NDK here, that comes next)

### Download Android NDK r12b
```bash
rm -rf ~/Android/Sdk/ndk-bundle/ \
&& cd ~/Downloads/ \
&& curl -o android-ndk.zip -L https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip \
&& sudo unzip android-ndk.zip -d ~/Android/Sdk/ \
&& mv ~/Android/Sdk/android-ndk-r12b ~/Android/Sdk/ndk-bundle \
&& rm android-ndk.zip \
&& sudo chmod -R 777 ~/Android/Sdk/ndk-bundle/* \
&& sudo chmod -R 777 ~/Android/Sdk/ndk-bundle
```

### Configure Environment Variables
```bash
sudo sh -c 'echo "PATH=~/bin:/usr/lib/jvm/java-6-oracle/bin:$PATH" >> ~/.profile' \
&& sudo sh -c 'echo "JAVA_HOME=/usr/lib/jvm/java-6-oracle" >> /etc/environment' \
&& sudo sh -c 'echo "ANDROID_HOME=$HOME/Android/Sdk" >> /etc/environment' \
&& sudo sh -c 'echo "ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk-bundle/" >> /etc/environment' \
&& sudo sh -c 'echo "10.98.100.24    jenkins.sciaps.local" >> /etc/hosts' \
&& sudo sh -c 'echo "10.98.100.25    jenkins2.sciaps.local" >> /etc/hosts' \
&& sudo sh -c 'echo "10.98.100.24    maven.sciaps.local" >> /etc/hosts'
```

### Unless you have 16G of Ram, you will need swap memory
[more on this here](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04)
```bash
sudo fallocate -l 16G /swapfile \
&& sudo chmod 600 /swapfile \
&& sudo mkswap /swapfile \
&& sudo swapon /swapfile
```

Make the Swap File Permanent:
```bash
sudo nano /etc/fstab
```

At the bottom of the file, you need to add a line that will tell the operating system to automatically use the file you created:
/swapfile   none    swap    sw    0   0

Hit CTRL+X and then Y to save and exit, and your swap is good to go.

### Make sure you are authorized for SciAps repositories
[more on this here](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#platform-linux)

Before running this command, change "Stephen Gowen" and "dev.sgowen@gmail.com" accordingly:
```bash
git config --global user.name "Stephen Gowen" \
&& git config --global user.email "dev.sgowen@gmail.com" \
&& ssh-keygen -t rsa -N "" -b 4096 -C "dev.sgowen@gmail.com" -f ~/.ssh/id_rsa \
&& eval "$(ssh-agent -s)" \
&& ssh-add ~/.ssh/id_rsa \
&& xclip -sel clip < ~/.ssh/id_rsa.pub \
&& xdg-open https://github.com/settings/ssh/new
```

1. Log in to GitHub, and then paste your clipboard into the Key box
2. Type Ubuntu AOSP into the Title box
3. Click *Add SSH key*
4. Restart your Ubuntu VM
5. Wait at least a full minute before proceeding

### Initialize and repo sync the SciAps fork of the Android 4.2.2 Firmware
```bash
sudo mkdir -p /opt/aosp \
&& cd /opt \
&& sudo chmod 777 aosp \
&& cd aosp \
&& repo --color=never init -u git@github.com:SciAps/android-manifest.git \
&& repo sync -f -c -j 4 --no-clone-bundle
```

Notes:
1. Be sure to answer "yes" and "Y" to all prompts
2. The --no-clone-bundle option saves prescious disk space by only performing shallow clones.

### Checkout correct revision of kernel and device trees:
```bash
cd /opt/aosp/kernel/sciaps/phenix \
&& git checkout libz_release_2.15 \
&& cd /opt/aosp/device/sciaps \
&& git checkout libz100_latest
```

### Enter build environment and make firmware image
```bash
cd /opt/aosp \
&& . build/envsetup.sh \
&& lunch full_phenix-eng \
&& m \
&& m root.ubi
```
If building firmware for LIBZ, the lunch command above can be replaced by:
```bash
lunch full_libz100-eng
```
Note that you can build just the kernel with:
```bash
m cleankernel && m kernel
```

*full_phenix-eng* Artifact File Sizes:
1. *root.ubi* should be 189,399,040 bytes (189.4 MB on disk)
2. *root.ubifs* should be 183,226,368 bytes (183.2 MB on disk)

### Flash Android Firmware from Master SD Card and Boot
1. Make sure your minicom tool is set up and listens to ttyUSB0. If it's not, set it up using the command below:
```bash
sudo minicom -s
```

2. Keep minicom lauched.
3. Copy or push (via adb) root.ubifs file to device internal memory and remember its location.
4. Reboot the instrument and see if the minicom is connected to the instrument. If it's nit, repeat the step #1
5. Interrupt the bootloader in minicom window by pressing enter key within 3s.
6. Then you need to mount the main device partition to get access to root.ubifs from the previous step.
   Note: Be careful! There is a possibility to brick the unit, so double check the commands you are entering, especially the path in 'copy' command.

```bash
mkdir /mnt \
&& mount /dev/disk0.0 /mnt/ \
&& ubiattach /dev/nand0.root \
&& cp /mnt/<path_to_your_file>/root.ubifs /dev/ubi0.root \
&& boot
```

### Flash Android Kernel from Master SD Card and Boot
If you cannot find the uImage file, check kernel/sciaps/phenix/arch/arm/boot folder (the path may be different for non-XFR models)
```bash
mkdir /mnt \
&& mount /dev/disk0.0 /mnt/ \
&& erase /dev/nand0.kernel.bb \
&& cp /mnt/<path_to_your_image>/uImage /dev/nand0.kernel.bb \
&& boot
```

### If you encounter any errors while following this guide...

1. UPDATE this guide.
2. If the error can be resolved via an *update* to one of the repositories, make the change on the firmware branch (create it if it doesn't exist) 
3. If a change was made to a repo, be sure to also update https://github.com/SciAps/android-manifest/blob/master/sciapsinstruments.xml to change the corresponding repository pointer to "firmware" if it is not already set
