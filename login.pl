#!/usr/bin/perl

use Mojo::Webqq;

# 注意:
# 程序内部数据全部使用UTF8编码，因此二次开发源代码也请尽量使用UTF8编码进行编写，否则需要自己做编码处理
# 在终端上执行程序，会自动检查终端的编码进行转换，以防止乱码
# 如果在某些IDE的控制台中查看执行结果，程序无法自动检测输出编码，可能会出现乱码，可以手动设置输出
# 手动设置输出编码参考文档中关于 log_encoding 的说明

# 帐号可能进入保护模式的原因:
# 多次发言中包含网址
# 短时间内多次发言中包含敏感词汇
# 短时间多次发送相同内容
# 频繁异地登陆

# 推荐手机安装[QQ安全中心]APP，方便随时掌握自己帐号的情况

# 新版本已无需指定qq号
# my $qq = 284759461;

# 初始化一个客户端对象，设置登录的qq号

my $client=Mojo::Webqq->new(
ua_debug    =>  0,         #是否打印详细的debug信息
log_level   => "info",     #日志打印级别
qq          =>  $qq,       #登录的qq帐号
login_type  =>  "qrlogin", #"qrlogin"表示二维码登录
);

# 注意: 腾讯可能已经关闭了帐号密码的登录方式，这种情况下只能使用二维码扫描登录

# 发送二维码到邮箱
# $client->load("PostQRcode",data=>{
# smtp    =>  'smtp.xxx.com', #邮箱的smtp地址
# port    =>  '25', #smtp服务器端口，默认25
# from    =>  'xxx@xxx.com', #发件人
# to      =>  'xxx@xxx.com', #收件人
# user    =>  'xxxxxxxxx', #smtp登录帐号
# pass    =>  'xxxxxxxxx', #smtp登录密码
# });

# 发送验证码到邮箱
# $client->load("PostImgVerifycode",data=>{
# smtp    =>  'smtp.xxx.com', #邮箱的smtp地址
# port    =>  '25', #smtp服务器端口，默认25
# from    =>  'xxx@xxx.com', #发件人
# to      =>  'xxx@xxx.com', #收件人
# user    =>  'xxxxxxxxx', #smtp登录帐号
# pass    =>  'xxxxxxxxx', #smtp登录密码
# post_host => '127.0.0.1' , #本机公网IP地址，需要远程访问
# post_port => '1987'            , #提交验证码的链接地址中使用的端口，默认1987
# });

# 客户端进行登录
$client->login();

# 主要用于主动更新好友、群、讨论组数据库，或者用于测试
$client->on(receive_message=>sub{
my $msg = $_[1];
  $client->relogin() if $msg->content eq "relogin";
  $client->_relink() if $msg->content eq "_relink";
  $client->relink() if $msg->content eq "relink";
  $client->update_user() if $msg->content eq "update_user";
  $client->update_group() if $msg->content eq "update_group";
  $client->update_group_ext() if $msg->content eq "update_group_ext";
  $client->update_friend() if $msg->content eq "update_friend";
  $client->update_friend_ext() if $msg->content eq "update_friend_ext";
  $client->update_discuss() if $msg->content eq "update_discuss";
});

# 客户端加载ShowMsg插件，用于打印发送和接收的消息到终端
$client->load("ShowMsg");

# 股票查询
$client->load("StockInfo");
# 示例：股票 000001

# 开启本地irc server
# 需要先安装Mojo::IRC::Server::Chinese
$client->load("IRCShell",data=>{
  host=>"127.0.0.1", #默认0.0.0.0
  port=>6667, #默认6667
        # master_irc_user     # 和qq匹配的irc user帐号，默认按照和qq号相同的user或者客户端ip是本机地址作为识别规则
        # load_friend         # 0|1 默认是1 是否初始为每个好友生成irc虚拟帐号并加入频道 #我的好友
        image_api => "http://paste.perfi.wang/",      # 兼容elimage图床api地址，将qq图片转为连接，方便在irc上查看图片，默认没有启用
});

#显示perl文档
#$client->load("Perlcode");
#示例 perldoc -f|-v xxx

#执行perl命令
#$client->load("Perldoc");
#示例 >>> print "hello world";

#代码测试
$client->load("ProgramCode");
#示例：code|c>>>
#        #include <stdio.h>
#        int main() {
#            printf("Hello World!\n");
#            return 0;
#        }

#手机归属地查询
$client->load("MobileInfo");
#示例：手机 1888888888

#创建知识库
$client->load("KnowledgeBase2",data=>{
        allow_group     => [ "PERL学习交流" ], # 可选，允许插件的群，可以是群名称或群号码
        ban_group       => [ "私人群", 123456 ], # 可选，禁用该插件的群，可以是群名称或群号码
        file            => './KnowledgeBase2.txt', # 数据库保存路径，纯文本形式，可以编辑
        learn_command   => 'learn', # 可选，自定义学习指令关键字
        delete_command  => 'del', # 可选，自定义删除指令关键字
        learn_operator  => [ 12345, 678910 ], # 允许学习权限的操作人qq号
        delete_operator => [ 12345, 678910 ], # 允许删除权限的操作人qq号
        mode            => 'fuzzy', # fuzzy|regex|exact 分别表示模糊|正则|精确, 默认模糊
        check_time      => 10, # 默认10秒检查一次文件变更
        show_keyword    => 1, # 消息是否包含触发关键字信息，默认开启
});

# 示例：learn 今天天气怎么样  天气很好
#      学习  "你吃了吗"      当然吃了
#      learn '哈哈 你真笨'   "就你聪明"
#      del   今天天气怎么样
#       删除  '哈哈 你真笨'

# 对大神进行鄙视
$client->load("FuckDaShen");

# 翻译
$client->load("Translation");
# 示例：翻译 hello

# 猜灯谜
$client->load("Riddle",data=>{
        allow_group => [ "PERL学习交流" ], # 可选，允许插件的群，可以是群名称或群号码
        ban_group   => [ "私人群", 123456 ], # 可选，禁用该插件的群，可以是群名称或群号码
        ban_user    => [ "坏蛋", 123456 ], # 可选，禁用该插件的用户，可以是用户的显示名称或qq号码
        command     => "猜谜", # 可选，触发关键字
        apikey      => "xxxx", # 可选，参见 http://apistore.baidu.com/apiworks/servicedetail/440.html?qq-pf-to=pcqq.c2c
        timeout     => 30, # 等待答案的超时时间，超时后会自动公布答案
});

# 显示油价
$client->load("GasPrice",data=>{
        allow_group => [ "PERL学习交流" ], # 可选，允许插件的群，可以是群名称或群号码
        ban_group   => [ "私人群", 123456 ], # 可选，禁用该插件的群，可以是群名称或群号码
        command     => "油价", # 可选，触发关键字
        apikey      => "xxxx", # 可选，参见 http://apistore.baidu.com/apiworks/servicedetail/710.html
        msg_tail    => "消息尾巴", # 可选
        is_need_at  => 0, # 是否需要艾特,默认值为0
});

# 每日签到
$client->load("Qiandao",data=>{
        allow_group         => [ "PERL学习交流" ], # 可选，允许插件的群，可以是群名称或群号码
        ban_group           => [ "私人群", 123456 ], # 可选，禁用该插件的群，可以是群名称或群号码
        is_qiandao_on_login => 0, # 可选，是否登录时进行签到，默认值为0
        qiandao_time        => "09:30",         # 可选，每日签到的时间，默认是 09:30
});

# 加载群管理
$client->load("GroupManage",data=>{
        allow_group       => [ "PERL学习交流" ], # 可选，允许插件的群，可以是群名称或群号码
        ban_group         => [ "私人群", 123456 ], # 可选，禁用该插件的群，可以是群名称或群号码
        new_group_member  => '欢迎新成员 @%s 入群[鼓掌][鼓掌][鼓掌]', # 新成员入群欢迎语，%s会被替换成群成员名称
        lose_group_member => '很遗憾 @%s 离开了本群[流泪][流泪][流泪]', # 成员离群提醒
        speak_limit       => { # 发送消息频率限制
            period       => 10, # 统计周期，单位是秒
            warn_limit   => 8, # 统计周期内达到该次数，发送警告信息
            warn_message => '@%s 警告, 您发言过于频繁，可能会被禁言或踢出本群', # 警告内容
            shutup_limit => 10, # 统计周期内达到该次数，成员会被禁言
            shutup_time  => 600, # 禁言时长
            # kick_limit      => 15,   # 统计周期内达到该次数，成员会被踢出本群
    },
        pic_limit         => { # 发图频率限制
        period          => 600,
        warn_limit      => 6,
        warn_message   => '@%s 警告, 您发图过多，可能会被禁言或踢出本群',
        shutup_limit    => 8,
        kick_limit      => 10,
    },
        keyword_limit     => {
        period=> 600,
        keyword=>[qw(fuck 傻逼 你妹 滚)],
        warn_limit=>3,
        shutup_limit=>5,
            # kick_limit=>undef,
    },
});

# smartQQ
$client->load("SmartReply", data => {
        apikey => 'd288214dcba801d180167635f3a8deb7', # 可选，参考http://www.tuling123.com/html/doc/apikey.html
        # allow_group     => ["PERL学习交流"],  # 可选，允许插件的群，可以是群名称或群号码
        # ban_group       => ["私人群",123456], # 可选，禁用该插件的群，可以是群名称或群号码
        # ban_user        => ["坏蛋",123456], # 可选，禁用该插件的用户，可以是用户的显示名称或qq号码
        # notice_reply    => ["对不起，请不要这么频繁的艾特我","对不起，您的艾特次数太多"], # 可选，提醒时用语
        # notice_limit    => 8 ,  # 可选，达到该次数提醒对话次数太多，提醒语来自默认或 notice_reply
        # warn_limit      => 10,  # 可选,达到该次数，会被警告
        # ban_limit       => 12,  # 可选,达到该次数会被列入黑名单不再进行回复
        # ban_time        => 1200,# 可选，拉入黑名单时间，默认1200秒
        # period          => 600, # 可选，限制周期，单位 秒
        # is_need_at      => 1,  # 默认是1 是否需要艾特才触发回复
        # keyword         => [qw(小灰 小红 小猪)], # 触发智能回复的关键字，使用时请设置is_need_at=>0
    });
# 需要私聊或@机器人

# 提供HTTP API接口，方便获取客户端帐号、好友、群、讨论组信息，以及通过接口发送和接收好友消息、群消息、群临时消息和讨论组临时消息
$client->load("Openqq",data=>{
        listen => [ { host => "127.0.0.1", port => 5011 }, ], # 监听的地址和端口，支持多个
        # auth   => sub {my($param,$controller) = @_},    # 可选，认证回调函数，用于进行请求鉴权
        # post_api => 'http://xxxx',                      # 可选，设置接收消息的上报接口
});

# 客户端开始运行
$client->run();
