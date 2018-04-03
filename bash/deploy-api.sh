#author 张国伟
#last update 2017-10-23

#!/bin/sh
export LANG=zh_CN.UTF-8

Version="1.0" #发布版本号
UserName="admin" #系统运行用户
TempDir="/home/"$UserName"/deploy/Temp/" #临时目录

basic_code_home="/home/"$UserName"/deploy/JavaCode/zm_business_video_basic_core" #服务后台Java源代码目录
web_code_home="/home/"$UserName"/deploy/JavaCode/zm_business_video_web_core" #站点后台Java源代码目录
open_api_tomcat_apps_home="/home/"$UserName"/tomcat/instance/api/webapps" #外部API部署目录


echo -e "\033[33m ======================开始更新代码========================== \033[0m"
cd $basic_code_home
svn update
echo -e "\033[33m ======================svn update basic_core success========================== \033[0m"
cd $web_code_home
svn update
echo -e "\033[33m ======================svn update web_core success========================== \033[0m"

echo -e '\n\n\n'
echo -e "\033[33m ======================maven 正在执行打包========================== \033[0m"

mvn clean install
echo -e "\033[33m ===========zm_business_video_api_webapp 打包成功===================== \033[0m"

cp $web_code_home/zm_business_video_api_webapp/target/zm_business_video_api_webapp.war  $TempDir/zm_business_video_api_webapp.war
echo -e "\033[33m =================open接口包文件收集完成====================== \033[0m"
echo -e '\n\n\n'


cp $TempDir/zm_business_video_api_webapp.war $open_api_tomcat_apps_home/ROOT.war
echo -e "\033[33m =============部署open接口包到tomcat成功！==================== \033[0m"


echo -e '\n\n\n'
echo -e "\033[33m "=============================================================" \033[0m"
echo -e "\033[33m "================视频接口模块发布完成！=======================" \033[0m"
echo -e "\033[33m "=============================================================" \033[0m"