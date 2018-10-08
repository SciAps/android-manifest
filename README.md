# Configuring Ubuntu 16.04 LTS Dev Environment

### Additional Resources
https://source.android.com/source/requirements

### Download Ubuntu 16.04 iso
https://www.ubuntu.com/download/alternative-downloads

### Preliminary steps for macOS Parallels users only
1. Open the Parallels Control Center and click on the *+* symbol in the top-right corner
2. Select the "Install Windows or another OS from DVD or image file" and click *Continue*
3. Drag an ubuntu 16.04 LTS iso into the "Installation Assistant" window and click *Continue*
4. Type in a password and click *Continue*
5. Check the "Customize settings before installation" checkbox and click *Create*
6. In the "Configuration" window, click on the *Hardware* tab
7. Bump up the memory to 4096MB at the minimum if you can
8. Bump up the graphics memory to 512 MB if you can
9. Under "Hard Disk", open the "Advanced Settings" and click on *Properties*
10. Drag the slider to 512 GB if you can and click *Apply*
11. Close the "Configuration" window and click *Continue*
12. Once Ubuntu is up and running, install Parallels Tools by clicking on the yellow icon in the top-right corner of the Ubuntu VM window

### Install Necessary Tools via apt-get
```bash
sudo apt-get update \
&& sudo apt-get -y install build-essential libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 git-core gnupg flex bison gperf zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip libswitch-perl default-jre u-boot-tools mtd-utils lzop xorg-dev libopenal-dev libglew-dev libalut-dev xclip python ruby-dev openvpn \
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
&& wget https://s3.amazonaws.com/sciaps/java-6-oracle.tar.gz \
&& sudo mkdir -p /usr/lib/jvm \
&& sudo tar xvzf java-6-oracle.tar.gz -C /usr/lib/jvm \
&& rm java-6-oracle.tar.gz \
&& sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-6-oracle/bin/java" 1337 \
&& sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-6-oracle/bin/javac" 1337
```

### Download and Install Android Studio
1. https://developer.android.com/studio/index.html
2. Click the big download button and accept the license
3. When prompted, just click "Save File"
4. Once downloaded, run the following: 
```bash
cd ~/Downloads && unzip android-studio-ide-*.zip \
&& sudo mv ~/Downloads/android-studio /opt/ \
&& cd ~/Downloads && rm android-studio-ide-*.zip \
&& /opt/android-studio/bin/studio.sh &
```
5. In the Android Studio Setup Wizard, click Custom
6. Use Defaults, keep clicking Next
7. On the Welcome to Android Studio screen, click the Configure option at the bottom and open the SDK Manager
8. Inside the SDK Manager, check the boxes for all API levels 10-19 and up under "SDK Platforms"; hit apply
9. Switch to the "SDK Tools" tab and check the boxes for CMake and Android SDK Build-Tools *20.0.0*, *21.1.2*, and *24.0.2* (check Show Package Details to see all the options); hit apply (do NOT install NDK here, that comes next)

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
&& repo sync -f -c -j 4 --no-clone-bundle --force-broken
```

If the above command does not immediately start git cloning, CTRL+C, run the following, and then try the above again:
```bash
cd /opt/aosp \
&& rm -rf .repo
```

### Entering the build environment and execution
If outside of the office, connect to VPN first before attempting to build
```bash
sudo openvpn --config file_you_get_from_gary_lortie.ovpn
```
Open a new Terminal and run the following:
```bash
cd /opt/aosp \
&& . build/envsetup.sh \
&& lunch full_phenix-eng \
&& rm -rf root* \
&& rm -rf /opt/aosp/out/target/product \
&& m \
&& chmod -R 777 out/target/product/phenix \
&& m root.ubi
```
If building firmware for LIBZ, the lunch command above can be replaced by:
```bash
lunch full_libz100-eng
```
If building firmware for Raman, the lunch command above can be replaced by:
```bash
lunch full_chem200-eng
```

Final *root.ubi* should be 190,054,400 bytes (190.1 MB on disk)
Final *root.ubifs* should be 183,861,248 bytes (183.9 MB on disk)

### If you encounter any errors while following this guide...

1. UPDATE this guide.
2. If the error can be resolved via an *update* to one of the repositories, make the change on the firmware branch (create it if it doesn't exist) 
3. If a change was made to a repo, be sure to also update https://github.com/SciAps/android-manifest/blob/master/sciapsinstruments.xml to change the corresponding repository pointer to "firmware" if it is not already set
