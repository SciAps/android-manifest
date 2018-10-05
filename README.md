# Configuring Ubuntu 16.04 LTS Dev Environment

### Additional Resources
https://source.android.com/source/requirements

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

### Create User Bin Folder
```bash
mkdir ~/bin
```

### Download Google's Repo Tool
```bash
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo \
&& chmod a+x ~/bin/repo
```

### Download flatc
```bash
curl https://s3.amazonaws.com/sciaps/flatc > ~/bin/flatc \
&& chmod a+x ~/bin/flatc
```

### Download gradle.properties file for your root ".gradle" folder
```bash
cd ~/Downloads \
&& wget https://s3.amazonaws.com/sciaps/gradle.properties \
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
9. Switch to the "SDK Tools" tab and check the boxes for CMake and Android SDK Build-Tools 20.0.0 (you may have to check Show Package Details); hit apply (do NOT install NDK here, that comes next)

### Download Android NDK r12b
```bash
rm -rf ~/Android/Sdk/ndk-bundle/ \
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
&& sudo sh -c 'echo "ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk-bundle/" >> /etc/environment'
```

Logout and Login again

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

1. Paste into the Key box
2. Type Ubuntu AOSP into the Title box
3. Click *Add SSH key*

### Initialize and repo sync the SciAps fork of the Android 4.2.2 Firmware

Run the following:
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
```bash
cd /opt/aosp \
&& . build/envsetup.sh \
&& lunch
```

then select either:
1. *full_phenix-eng* for XRF
2. *full_libz100-eng* for LIBZ
3. *full_chem200-eng* for Raman

### Build the ubi
```bash
make -j4 \
&& make root.ubi
```

### Regarding Errors...

1. If you encounter any errors while following this guide, UPDATE this guide.
2. If you encounter any errors while following this guide that can be resolved via an update to ANY of the repositories, make a Pull Request for that change and a Pull Request for https://github.com/SciAps/android-manifest (to update the corresponding repository pointer)
