#!/bin/bash

# 发送的群号
Gnumber=$1

# 你login.pl中定义的host和port
API_ADDR="127.0.0.1:5011"

# 处理下编码，用于合并告警内容的标题和内容，即$2
message=$(echo -e "$2" | od -t x1 -A n -v -w10000 | tr " " %)

# 这没什么好说的
api_url="http://$API_ADDR/openqq/send_group_message?uid=$Gnumber&content=$message"
set -x
curl $api_url
set +x
