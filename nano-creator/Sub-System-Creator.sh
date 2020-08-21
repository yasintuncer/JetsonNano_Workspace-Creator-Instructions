echo "Welcome To Sysroot Creator for the Jetson Nano  "
DIR=${PWD}
mkdir ../../Devices ../../Devices/nano-workspace 
DEV_ROOT=../../Devices/nano-workspace
cd ${DEV_ROOT}
DEV_ROOT=${PWD}
cd ${DIR}
DEV_SYSROOT=${DEV_ROOT}/sysroot
if [ -d ${DEV_SYSROOT} ];then
{
    echo "Sysroot directory already exists"
    echo "Do you want to remove directory? (yes/no)"
    read value
    if [ $value == "yes" ];then
    {
        sudo rm -r ${DEV_SYSROOT}
        if [ ! -d ${DEV_SYSROOT} ];then
            echo "Sysroot Directory is succesfully removed."
            mkdir ${DEV_SYSROOT}
        else
        {
            echo "Sysroot Directory cannot removed"
            exit 1       
        }
        fi
    }
    fi
    
            
}
else 
{   
    echo "Sysroot Directory is created"
    mkdir ${DEV_SYSROOT}
}
fi

UserName="nano"
Hostname="nano"
echo "Please enter the Device username"
read value
UserName="$value"
echo "Please enter the Device Hostname or Ip-address"
read value
HostName="$value"

Device="$UserName@$HostName"
echo $Device

echo "#########################################################################"
echo 
echo "Start synchronizing the sysroot folders"
echo "Please sure to be connected Jetson Nano"
echo 
echo "#########################################################################"
echo "(press enter to continue)"
read value
echo 

echo "Connecting Device addresss : $Device"
echo "Do you want to connect this address (yes/no)"
read value
echo 
if [ $value != "yes" ];then 
    exit 1
fi

cd ${DEV_SYSROOT}
rsync -avz "$Device":/lib ${DEV_SYSROOT}
echo "........Completed........"
echo "(press enter to continue)"
read value

rsync -avz "$Device":/usr/include ${DEV_SYSROOT}/usr
echo "........Completed........"
echo "(press enter to continue)"
read value
echo 

rsync -avz "$Device":/usr/lib ${DEV_SYSROOT}/usr
echo "........Completed........"
echo "(press enter to continue)"
read value
echo 

rsync -avz "$Device":/usr/local ${DEV_SYSROOT}/usr
echo "........Completed........"
echo "(press enter to continue)"
read value
echo 

rsync -avz "$Device":/usr/share ${DEV_SYSROOT}/usr
echo "........Completed........"
echo "(press enter to continue)"
read value
echo 

rsync -avz "$Device":/opt ${DEV_SYSROOT}/opt
echo "........Completed........"
echo "(press enter to continue)"
read value
echo 

echo "Synchronizing Finished"
echo "....................................."
echo 
echo
echo
echo "Starting relative path solver"
cd ${DEV_ROOT}
if [ ! -f  "sysroot-relativelinks.py" ];then
    wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
fi

chmod +x sysroot-relativelinks.py
./sysroot-relativelinks.py sysroot

echo "Synchronizing and relative links processs completed in sysroot"


