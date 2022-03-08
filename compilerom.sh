#!/bin/bash
echo "Did You Installed Required Packages and Repo tool?"
echo "1.Yes, I Had Installed"
echo "2.NO, I didn't Installed"
echo "Enter your Option :"
read packages
if [ $packages -eq 2 ]
then
cd
sudo apt-get update -y
sudo apt install -y git git-lfs bc bison ccache clang cmake flex libelf-dev lld ninja-build python3 tmate u-boot-tools zlib1g-dev rclone curl wget build-essential devscripts fakeroot psmisc qemu-kvm unzip zip rsync make default-jdk gnupg flex gperf gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
sudo install repo /usr/local/bin
rm repo
git clone https://github.com/navin136/scripts.git scripts && cd scripts
bash setup/android_build_env.sh
cd
rm -rf scripts
git config --global user.name "navin136"
git config --global user.email "nkwhitehat@gmail.com"
git config --global credential.helper store
else
read -p "Give me Repo link of Rom :" repoLink
read -p "Which branch of Repo You want to Sync:" repoBranch
romDir=$(echo $repoLink|cut -d "/" -f 4)
if [ -d $romDir ]
then
cd $romDir
export ROM=$(pwd)
rm -rf $ROM/device/asus/X00T && git clone https://github.com/X00T-dev/device_asus_X00T -b 12 $ROM/device/asus/X00T && rm -rf $ROM/vendor/asus && git clone https://github.com/X00T-dev/vendor_asus -b 12 $ROM/vendor/asus --depth=1 && rm -rf $ROM/kernel/asus/sdm660 && git clone https://github.com/arrowos-devices/android_kernel_asus_X00T $ROM/kernel/asus/sdm660 --depth=1
rm -rf $ROM/hardware/qcom-caf/sdm660/audio && git clone https://github.com/X00T-dev/hardware_qcom-caf_sdm660_audio $ROM/hardware/qcom-caf/sdm660/audio && rm -rf $ROM/hardware/qcom-caf/sdm660/display && git clone https://github.com/navin136/hardware_qcom-caf_sdm660_display $ROM/hardware/qcom-caf/sdm660/display
sudo mkdir /mnt/ccache
sudo mount ../.cache /mnt/ccache
export CCACHE_DIR=/mnt/ccache
romVendorName=$(ls device/asus/X00T/*_X00T.mk | cut -d "/" -f 4 | cut -d "_" -f 1)
. b*/e*
lunch $(romVendorName)_X00T-userdebug
make bacon -j$(nproc --all) | tee log.txt
else
mkdir $romDir
cd $romDir
export ROM=$(pwd)
repo init -u $repoLink -b $repoBranch --depth=1
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
rm -rf $ROM/device/asus/X00T && git clone https://github.com/X00T-dev/device_asus_X00T -b 12 $ROM/device/asus/X00T && rm -rf $ROM/vendor/asus && git clone https://github.com/X00T-dev/vendor_asus -b 12 $ROM/vendor/asus --depth=1 && rm -rf $ROM/kernel/asus/sdm660 && git clone https://github.com/arrowos-devices/android_kernel_asus_X00T $ROM/kernel/asus/sdm660 --depth=1
rm -rf $ROM/hardware/qcom-caf/sdm660/audio && git clone https://github.com/X00T-dev/hardware_qcom-caf_sdm660_audio $ROM/hardware/qcom-caf/sdm660/audio && rm -rf $ROM/hardware/qcom-caf/sdm660/display && git clone https://github.com/navin136/hardware_qcom-caf_sdm660_display $ROM/hardware/qcom-caf/sdm660/display
sudo mkdir /mnt/ccache
sudo mount ../.cache /mnt/ccache
export CCACHE_DIR=/mnt/ccache
romVendorName=$(ls device/asus/X00T/*_X00T.mk | cut -d "/" -f 4 | cut -d "_" -f 1)
. b*/e*
lunch $(romVendorName)_X00T-userdebug
make bacon -j$(nproc --all) | tee log.txt
fi
fi
fi
curl --upload-file out/target/product/X00T/*X00T*.zip https://free.keep.sh/$romVendorName*X00T*.zip > build.txt
function sendLink(){
    curl -X POST https://api.telegram.org/bot1906657636:AAEl8FIiy0kDff0pFoLodnO-Vwg6JNG5FZg/sendMessage -d chat_id="-1001509079419" -d text=$1
}
sendLink $(cat build.txt)