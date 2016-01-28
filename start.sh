#!/bin/bash
SH=$1;
>nohup.out;
nohup ./$SH &
tail nohup.out;
exit;
