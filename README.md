# Mojo-Webqq-Scripts
<h1>Mojo::Webqq项目使用示例</h1>

<pre>
使用说明：
1.login_dba.pl
  登录脚本，用来登录qq，加载插件，已集成openqq，需后台运行。
  使用方法：
  perl login_dba.pl &

2.qq_sms_dba.sh
  openqq发送信息的脚本，执行时需自行添加群号。
  使用方法：
  sh qq_sms_dba.sh 群号 信息

3.start.sh/stop.sh
  通用的启动和停止脚本，启动时会自动后台运行并输出相关日志，后面需跟脚本名。
  使用方法：
  sh start.sh/stop.sh login_dba.pl

4.restart_login_dba.sh
  自动调用stop.sh和start.sh重启进程，此处只针对login_dba.pl。
  使用方法：
  sh restart_login_dba.sh
</pre>
