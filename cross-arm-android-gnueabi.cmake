#
# CMake Toolchain file for crosscompiling on ARM.
#
# This can be used when running cmake in the following way:
#  cd build/
#  cmake .. -DCMAKE_TOOLCHAIN_FILE=../cross-arm-android-gnueabi.cmake
#

set(CROSS_PATH "$ENV{ANDROID_BUILD_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6")

# Target operating system name.
set(CMAKE_SYSTEM_NAME Android)

# Target build dynamic libs.
set(BUILD_SHARED_LIBS ON)

# Name of C compiler.
set(CMAKE_C_COMPILER "${CROSS_PATH}/bin/arm-linux-androideabi-gcc")
set(CMAKE_CXX_COMPILER "${CROSS_PATH}/bin/arm-linux-androideabi-g++")
set(CMAKE_C_FLAGS
"       -nostdlib -lm -lstdc++ -lc -ldl \
        -Bdynamic -Wl,-dynamic-linker,/system/bin/linker \
        -I$ENV{ANDROID_BUILD_TOP}/hardware/libhardware_legacy/include \
        -I$ENV{ANDROID_BUILD_TOP}/hardware/libhardware_legacy/include/hardware_legacy \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libc/kernel/common/linux/can \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libm/include \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libc/include \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libc/arch-arm/include \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libstdc++/include \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libc/kernel/common \
        -I$ENV{ANDROID_BUILD_TOP}/bionic/libc/kernel/arch-arm \
        -L$ENV{ANDROID_PRODUCT_OUT}/obj/lib \
")

set(OPENSSL_ROOT_DIR "$ENV{ANDROID_BUILD_TOP}/external/openssl")
set(OPENSSL_INCLUDE_DIR "$ENV{ANDROID_BUILD_TOP}/external/openssl/include")
set(OPENSSL_CRYPTO_LIBRARY "$ENV{ANDROID_PRODUCT_OUT}/obj/lib/libcrypto.so")
set(OPENSSL_SSL_LIBRARY "$ENV{ANDROID_PRODUCT_OUT}/obj/lib/libssl.so")

#
# Different build system distros set release optimization level to different
# things according to their local policy, eg, Fedora is -O2 and Ubuntu is -O3
# here.  Actually the build system's local policy is completely unrelated to
# our desire for cross-build release optimization policy for code built to run
# on a completely different target than the build system itself.
#
# Since this goes last on the compiler commandline we have to override it to a
# sane value for cross-build here.  Notice some gcc versions enable broken
# optimizations with -O3.
#
if (CMAKE_BUILD_TYPE MATCHES RELEASE OR CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES release)
#	set(CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE} -O3)
#	set(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE} -O3)
endif()

# Where to look for the target environment. (More paths can be added here)
set(CMAKE_FIND_ROOT_PATH "${CROSS_PATH}")

# Adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search headers and libraries in the target environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
