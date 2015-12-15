#!/bin/bash
SH=$1;
>nohup.out;
nohup $SH &;
tail -f nohup.out;
exit;
