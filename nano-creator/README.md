
## BUILD JETSON-NANO Platform
cd ${REPO_PATH}/platform-tools

cd nano-creator

chmod +x Sub-System-Creator.sh
./Sub-System-Creator.sh
chmod +x Qt-build.sh
./Qt-build.sh


