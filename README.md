# Mojo-Webqq-Scripts
## Mojo::Webqq项目地址:
[Mojo::Webqq](https://github.com/sjdy521/Mojo-Webqq)  
感谢[灰灰](https://github.com/sjdy521)的倾情付出.

```
使用说明:
1.login.pl
  登录脚本,用来登录qq,加载插件,已集成openqq,需自行修改QQ号及后台运行.
  使用方法:
  perl login.pl &

2.qq_sms.sh
  openqq发送信息的脚本,执行时需自行添加群号.
  使用方法:
  sh qq_sms.sh 群号 信息

3.start.sh/stop.sh
  通用的启动和停止脚本,启动时会自动后台运行并输出相关日志,并在终端显示二维码,后面需跟脚本名.
  其中start.sh脚本需修改png文件名.
  使用方法:
  sh start.sh/stop.sh login.pl

4.restart.sh
  重启webqq并自动获取二维码打开.
  sh restart.sh
```
