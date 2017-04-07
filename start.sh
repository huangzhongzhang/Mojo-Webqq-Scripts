#!/bin/bash
SH=$1
>nohup.out
rm -f /tmp/mojo_webqq_*
nohup ./$SH &
sleep 5
./viewqr /tmp/mojo_webqq_qrcode_default.png
exit
