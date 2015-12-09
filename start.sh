#!/bin/bash
SH=$1

sh -c "$SH &" &> $SH.log

tail -f $SH.log

exit
