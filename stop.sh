#!/bin/bash
SH=$1
ps -ef | grep $SH | grep perl | grep -v grep | awk '{print $2}' | xargs kill -9
exit
