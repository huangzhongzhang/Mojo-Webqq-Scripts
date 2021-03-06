#!/bin/bash
set -x;

cd $(dirname $0);

# 发送的群名称
Gname=$1

# 你login.pl中定义的host和port
API_ADDR="127.0.0.1:5011"

# 处理下编码，用于合并告警内容的标题和内容，即$2
message=$(echo -e "$2" | od -t x1 -A n -v -w10000 | tr " " %)

# 获取GID，需要先安装 epel-release, jq 和 bc
GID=$(curl -s "http://$API_ADDR/openqq/get_group_basic_info"|jq '.[]|{name,id}'|tr -d "{,}\""|grep -A 1 -B 1 "$Gname"|grep -v "$Gname"|awk '{print $2}'|bc)

# 发送信息
api_url="http://$API_ADDR/openqq/send_group_message?id=$GID&content=$message"
set -x
curl $api_url
set +x
