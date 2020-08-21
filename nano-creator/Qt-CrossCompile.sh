#!/bin/bash
source util.sh
echo "##########################################################################"
echo "                                                                          "
echo -e "              ${RED}Welcome To the JETSON-NANO QT Installiation${NOCOLOR} "
echo 
echo "  This Script includes build instruction of the Qt on the Host side       " 
echo "for the target device and host pc."
echo "                                                                          "
echo "##########################################################################"
echo -e "\n\n"


##################################################################################
# Device Info
##################################################################################
UserName="nano"
HostName="nano"
Device_address="nano" 
TOOLKIT="gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
QTREPONAME="qt-5-repo"
##################################################################################

##################################################################################
#Default Directories
##################################################################################
    BASE_DIR=${PWD}
    cd ..
    cd ..
    if [ ! -d "Devices" ];then
    {
        mkdir Devices
    }
    fi

    cd Devices
    if [ ! -d "nano-workspace" ];then
    {
        mkdir nano-workspace
    }
    fi
    cd nano-workspace
    DEV_ROOT=${PWD}
    SYSROOT=${DEV_ROOT}/sysroot
    cd ${BASE_DIR}
    cd ..
    QT_REPOSITORY_DIR=${PWD}
    QT_ROOT_DIR=${DEV_ROOT}/Qt
    QT_INSTALL_DIR=${QT_ROOT_DIR}/install
    QT_HOST_PREFIX_DIR=${QT_INSTALL_DIR}/qt5-host
    QT_PREFIX_DIR=${QT_INSTALL_DIR}/qt5
    QT_DEVICE_PREFIX=${QT_INSTALL_DIR}/qt5-nano
    TOOLKIT_DIR=${DEV_ROOT}/$TOOLKIT
##################################################################################

##################################################################################
# Directory creater function
##################################################################################
set_directory()
{
    BASE_DIR=$1
    cd ../
    if [ ! -d "Devices" ];then
    {
        mkdir Devices
    }
    fi

    cd Devices
    if [ ! -d "nano-workspace" ];then
    {
        mkdir nano-workspace
    }
    fi
    cd nano-workspace
    DEV_ROOT=${PWD}
    SYSROOT=${DEV_ROOT}/sysroot
    cd ${BASE_DIR}
    cd ..
    DIR=${PWD}
    QT_REPOSITORY_DIR=${DIR}
    QT_ROOT_DIR=${DEV_ROOT}/Qt
    QT_INSTALL_DIR=${QT_ROOT_DIR}/install
    QT_HOST_PREFIX_DIR=${QT_INSTALL_DIR}/qt5-host
    QT_PREFIX_DIR=${QT_INSTALL_DIR}/qt5
    QT_DEVICE_PREFIX=${QT_INSTALL_DIR}/qt5-nano
    cd ${DEV_ROOT}
    mkdir ${QT_ROOT_DIR} 
    mkdir ${QT_ROOT_DIR}/install
    mkdir ${QT_DEVICE_PREFIX} ${QT_PREFIX_DIR} ${QT_HOST_PREFIX_DIR}
}
##################################################################################
# Echo Director function
##################################################################################
echo_directory (){

echo -e "${DIR_TEXT}Directories${DEF_TEXT}\n"
echo 
echo -e "${DIR_TEXT}BASE_DIR${DEF_TEXT}     :   ${BASE_DIR}\n"
echo -e "${DIR_TEXT}DEV_ROOT${DEF_TEXT}     :   ${DEV_ROOT}\n"
echo -e "${DIR_TEXT}SYSROOT${DEF_TEXT}      :   ${SYSROOT}\n"
echo
echo -e "${DIR_TEXT}QT Directories${DEF_TEXT}\n"
echo -e "${DIR_TEXT}QT_REPOSITORY_DIR${DEF_TEXT}       :   ${QT_REPOSITORY_DIR}\n"
echo -e "${DIR_TEXT}QT_ROOT_DIR${DEF_TEXT}              :   ${QT_ROOT_DIR}\n"
echo -e "${DIR_TEXT}QT_INSTALL_PREFIX_DIR${DEF_TEXT}    :   ${QT_INSTALL_DIR}\n"
echo -e "${DIR_TEXT}QT_HOST_PREFIX_DIR_DIR${DEF_TEXT}   :   ${QT_HOST_PREFIX_DIR_DIR}\n"
echo -e "${DIR_TEXT}QT_PREFIX_DIR${DEF_TEXT}            :   ${QT_PREFIX_DIR}\n"
echo -e "${DIR_TEXT}QT_DEVICE_PREFIX_DIR${DEF_TEXT}     :   ${QT_DEVICE_PREFIX}\n"
echo -e "\n\n\n\n\n"
}


echo_directory
echo -e "${QUES_TEXT}Build directories are upstairs. Do you use default directories?(yes/no)${DEF_TEXT}"
read value
echo -e "\n"

if [ $value != "yes" ];then
    {
        echo "BASE_DIR  :"
        read DEV_PATH
        set_directory $DEV_PATH
        echo "New Directories are below"
        echo_directory
        echo -e "${QUES_TEXT}Enter the continue....${DEF_TEXT}"
        read value
    }
else
    {
        DEV_PATH=${BASE_DIR} 
    
        set_directory ${DEV_PATH}
    }
fi

echo -e "${SUCCES_TEXT}Directories has been verified succesfully!${DEF_TEXT}"
echo -e "\n"
echo -e "${SUCCES_TEXT}Directories Are Created...${DEF_TEXT}"
echo 

cd ${DEV_ROOT}
echo -e "${INIT_TEXT}Check Git.. ${DEF_TEXT}"
dpkg-query -l git
if [ $? != 0 ];then
{   echo -e "${INIT_TEXT}Git installing... ${DEF_TEXT}"
    apt-get install git git-core -y
    echo -e "${SUCCES_TEXT}git installed. ${DEF_TEXT}"
}
else
{
    echo -e "${SUCCES_TEXT}Git already installed${DEF_TEXT}"
}
fi

echo -e "${INIT_TEXT}Check relative path solver.. ${DEF_TEXT}"
cd ${DEV_ROOT}
if [ ! -f ""sysroot-relativelinks.py"" ];then
{   echo -e "${INIT_TEXT} Donwloading relative path solver... ${DEF_TEXT}"
    wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
    echo -e "${SUCCES_TEXT}Downloaded relative path solver.. ${DEF_TEXT}"
    chmod +x ${DEV_ROOT}/sysroot-relativelinks.py
}
else
{
    echo -e "${SUCCES_TEXT}relative path solver already exist.${DEF_TEXT}"
}
fi

echo -e "${INIT_TEXT}Check Subsytem folder.(JETSON NANO)${DEF_TEXT}"
cd ${DEV_ROOT}
if [ ! -d "sysroot" ];then
{
    cd ${BASE_DIR}
    if [ ! -f "Sub-System-Creator.sh" ];then
    {
        echo -e "${ERROR_TEXT}ERROR    :   CANNOT find 'Sub-System-Creator.sh'!!\n"
        echo -e "Check The "platform-tools" repository."
        echo -e "EXITING..."
        exit
    }
    else
    {
        chmod +x Sub-System-Creator.sh
        ./Sub-System-Creator.sh
        echo -e "${SUCCES}Sysroot Created.${DEF_TEXT}"
    }
    fi
}
fi

cd ${DEV_ROOT}
./sysroot-relativelinks.py ${SYSROOT}

cd ${DEV_ROOT}
echo -e  "${INIT_TEXT}Check gcc-linaro toolkit${DEF_TEXT}"
if [ ! -d "gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu" ];then
{
    echo -e "${INIT_TEXT}Clonning Jetson Nano aarch64-linux-gnu toolchain repo.. ${DEF_TEXT}"
    wget https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/aarch64-linux-gnu/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz
    tar -xvf gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz
    sudo rm -r gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz


}
fi
echo -e "${SUCCES_TEXT}gcc-linaro succesfully cloned. ${DEF_TEXT}"
cd ${DEV_ROOT}
./sysroot-relativelinks.py ${TOOLKIT_DIR}

cd ${QT_REPOSITORY_DIR}
if [ ! -d qt-5-repo ];then
{
    echo -e "${INIT_TEXT}Clonning Qt repository${DEF_TEXT}"
    git clone git://code.qt.io/qt/qt5.git -b 5.13.0 qt-5-repo
}
else
{
    cd qt-5-repo
    #git clean
}
fi
echo -e "${SUCCES_TEXT}Clonned Qt.${DEF_TEXT}"

QTBASE_DIR=${QT_REPOSITORY_DIR}/$QTREPONAME
cd ${QTBASE_DIR}
echo "Repository initializing....."
./init-repository
cd qtbase
./configure \
-device linux-jetson-tx1 \
-device-option CROSS_COMPILE=${TOOLKIT_DIR}/bin/aarch64-linux-gnu- \
-sysroot ${SYSROOT} \
-I ${SYSROOT}/usr/include/c++/7 -L ${SYSROOT}/usr/lib/gcc/aarch64-linux-gnu/7 \
-nomake examples -nomake tests \
-make libs \
-prefix ${QT_PREFIX_DIR} -extprefix ${QT_DEVICE_PREFIX} -hostprefix ${QT_HOST_PREFIX_DIR} \
-no-use-gold-linker -v -no-gbm

echo -e "${WARNING_TEXT}Configuration finished. Please check to its correct!${DEF_TEXT}"
echo -e "${QUES_TEXT}Did you get any error when configuriation(yes/no)${DEF_TEXT}"
read value
if [ $value != "yes" ];then
{
    echo -e "${WARNING_TEXT}Please check-in QT configuration parameters for occurred error.${DEF_TEXT}"
    echo -e "${WARNING_TEXT}parameters address is the lines of between 231-238  at Qt-cross-compiler.sh  file.${DEF_TEXT}"
    echo "Exiting..."
    exit
}
fi
echo -e "${INIT_TEXT}Configuration done.Please enter the continue...${DEF_TEXT}"
read value
echo -e "${INIT_TEXT}Starting Make...${DEF_TEXT}"

make -j4
if [ ! $? -eq 0 ];then
{
     echo -e "${ERROR_TEXT}Make error!!${DEF_TEXT}"
     echo -e "Exiting..."
     exit
}
fi

echo -e "${SUCCES_TEXT}QT Cross-Build Process Succesfully finished...${DEF_TEXT}"
echo -e "${INIT_TEXT}Please enter the continue...${DEF_TEXT}"
read value
echo -e "${INIT_TEXT}Startin make install...${DEF_TEXT}"
make install
if [ ! $? -eq 0 ];then
{
     echo -e "${ERROR_TEXT}Make install error!!${DEF_TEXT}"
     echo -e "Exiting..."
     exit
}
fi
cd ${DEV_ROOT}
#./sysroot-relativelinks.py ${Qt}

echo -e "${SUCCES_TEXT}Finished QT Make install. Please Enter the continue.${DEF_TEXT}"
read value
