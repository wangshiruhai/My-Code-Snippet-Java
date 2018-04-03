#author wangshihai
#last update 2017-10-24

#!/bin/sh
export LANG=zh_CN.UTF-8


read -p "请输入将要部署模式(例如:simple|normal): " DeployType

DeployType=${DeployType:-simple}
echo "启动模式:" $DeployType


Version="1.0" #发布版本号
UserName="admin" #系统运行用户
TempDir="/home/"$UserName"/deploy/Temp/" #临时目录

source_base_home="/home/"$UserName"/deploy/JavaCode/"  #basic webapp 源代码目录

basic_webapp_home=$source_base_home"/zm_business_video_basic_core"  #basic webapp 源代码目录
web_webapp_home=$source_base_home"/zm_business_video_web_core"  #web webapp 源代码目录
wap_home=$source_base_home"/zm_business_video_web_core/zm_business_video_wap"  #wap 源代码目录

video_web_tomcat_apps_home="/home/"$UserName"/tomcat/instance/web/webapps" #视频网站部署目录

echo -e "\033[33m ======================开始更新代码========================== \033[0m"
cd $basic_webapp_home
svn update
echo -e "\033[33m ======================更新代码完成========================== \033[0m"
echo -e '\n\n\n'
echo -e "\033[33m ======================正在执行打包========================== \033[0m"

cd $basic_webapp_home

if [ $DeployType == 'simple' ]; then
	mvn clean install |sed -n '/BUILD /,+0p'
else
	mvn clean install
fi

echo -e "\033[33m ============zm_business_video_basic打包成功==================== \033[0m"

cp $basic_webapp_home/zm_business_video_basic_webapp/target/zm_business_video_basic_webapp.war  $TempDir/basic_webapp.war
echo -e "\033[33m ====================basic_web包文件收集完成======================== \033[0m"
echo -e '\n'


cd $web_webapp_home

if [ $DeployType == 'simple' ]; then
	mvn clean install |sed -n '/BUILD /,+0p'
else
	mvn clean install
fi

echo -e "\033[33m ============zm_business_video_web打包成功==================== \033[0m"

scp $web_webapp_home/zm_business_video_web_webapp/target/zm_business_video_web_webapp.war  $TempDir/web_webapp.war
echo -e "\033[33m ====================webapp包文件收集完成======================== \033[0m"
echo -e '\n'

cd $wap_home

if [ $DeployType == 'simple' ]; then
	mvn clean install |sed -n '/BUILD /,+0p'
else
	mvn clean install
fi

scp $wap_home/target/zm_business_video_wap.war  $TempDir/web_wap.war

echo -e "\033[33m ====================wap包文件收集完成======================== \033[0m"
echo -e '\n'

scp $TempDir/basic_webapp.war $video_web_tomcat_apps_home/admin.war
echo -e "\033[33m ===============部署视频admin包到tomcat成功！=================== \033[0m"

scp $TempDir/web_webapp.war $video_web_tomcat_apps_home/ROOT.war
echo -e "\033[33m ===============部署视频webapp包到tomcat成功！=================== \033[0m"

scp $TempDir/web_wap.war $video_web_tomcat_apps_home/wap.war
echo -e "\033[33m ===============部署视频wap包到tomcat成功！=================== \033[0m"

echo -e '\n\n\n'
echo -e "\033[33m "=============================================================" \033[0m"
echo -e "\033[33m "=================视频Web模块发布完成！=======================" \033[0m"
echo -e "\033[33m "=============================================================" \033[0m"
