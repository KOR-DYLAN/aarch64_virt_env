#!/bin/bash
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

TOP_DIR=$(realpath "$SCRIPTPATH/../..")
BINARY_DIR=$TOP_DIR/bin

ARM_URL_PREFIX=https://developer.arm.com/-/media/Files/downloads
ARM_PROFILE=gnu-a
ARM_VERSION=10.3-2021.07

TARGET="aarch64-none-linux-gnu"
TARGET_FILE=gcc-arm-${ARM_VERSION}-${HOSTTYPE}-${TARGET}.tar.xz
TARGET_URL=${ARM_URL_PREFIX}/${ARM_PROFILE}/${ARM_VERSION}/binrel/${TARGET_FILE}

if [ ! -e ${TARGET_FILE} ]; then
    echo "wget ${TARGET_URL}"
    wget ${TARGET_URL}
fi

if [ ! -d ${BINARY_DIR}/gcc-arm-${ARM_VERSION}-${HOSTTYPE}-${TARGET} ]; then
    echo "tar Jxvf ${TARGET_FILE} -C $BINARY_DIR"
    tar Jxvf ${TARGET_FILE} -C $BINARY_DIR

    echo "${BINARY_DIR}/${TARGET}"
    rm -f ${BINARY_DIR}/${TARGET}

    echo "ln -s ${BINARY_DIR}/gcc-arm-${ARM_VERSION}-${HOSTTYPE}-${TARGET} ${BINARY_DIR}/${TARGET}"
    ln -s ${BINARY_DIR}/gcc-arm-${ARM_VERSION}-${HOSTTYPE}-${TARGET} ${BINARY_DIR}/${TARGET}
fi
