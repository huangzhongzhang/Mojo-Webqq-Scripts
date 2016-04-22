#!/bin/bash
SH=$1;
>nohup.out;
rm -f /tmp/mojo_webqq_*;
nohup ./$SH &
sleep 15;
./viewqr /tmp/mojo_webqq_qrcode_284759461.png;
tail nohup.out;
exit;
