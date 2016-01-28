#!/usr/bin/env bash
set -e

HT=127.0.0.1
US=hzz
PW=11111111

#远程重启
expect -c "
  spawn ssh ${US}@${HT}
  expect {
    \"not known\" {send_user \"[exec echo -e Erro:Host not known\n];exit\"}
    \"Connection refused\" {send_user \"[exec echo -e Erro:Connection refused\n];exit\"}
    \"(yes/no)?\" {send \"yes\r\";exp_continue}
    \"password:\" {send \"${PW}\r\";exp_continue}
    \"Permission denied\" {send_user \"[exec echo -e Erro:Wrong passwd\n];exit\"}
    \"]*\" {send \"\r\"}
    \">*\" {send \"\r\"}
    \"$*\" {send \"\r\"}
  }
  send \"cd /home/hzz/workspace/webqq/Mojo-Webqq-Scripts;./stop.sh login_dba.pl;./start.sh login_dba.pl;sleep 1;\rexit\r\"
"
#删除本地文件
rm -f /tmp/mojo_webqq_qrcode_2774984191.png
sleep 1

#获取二维码
expect -c "
  spawn scp ${US}@${HT}:/tmp/mojo_webqq_qrcode_284759461.png /tmp
  expect {
    \"password\" {send \"$PW\r\";exp_continue;}
    \">*\" {send \"\r\"}
    \"]*\" {send \"\r\"}
  }
"

#调用本地软件读取二维码
eog /tmp/mojo_webqq_qrcode_284759461.png;

exit;
