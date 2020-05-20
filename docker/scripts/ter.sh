#!/bin/sh

TARGET_SCRIPT=/home/appl-user/prj/TER/ter.lisp

LOG_DIR=/home/appl-user/var/log/TER/

BOOT_LOG=/home/appl-user/var/log/TER/boot.log

/usr/bin/sbcl --script $TARGET_SCRIPT >> $BOOT_LOG
