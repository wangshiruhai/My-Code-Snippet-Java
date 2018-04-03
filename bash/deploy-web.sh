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



if [ $DeployType == 'simple' ]; then
        pre_result=`echo -e "\033[33m 正在打包部署 \033[0m"`
	echo -e $pre_result "\033[5m ...... \033[0m" 
        cd $source_base_home
        svn update > /dev/null 2>&1

	echo -e '\n'
	echo 0 | awk -F ' ' '{print " 名称\t\t打包结果";print "-----------------------";}' 
else
	echo -e "\033[33m ======================开始更新代码========================== \033[0m"
	cd $source_base_home
        svn update
        echo -e "\033[33m ======================更新代码完成========================== \033[0m"
        echo -e '\n\n\n'
        echo -e "\033[33m ======================正在执行打包========================== \033[0m"
fi

cd $basic_webapp_home
if [ $DeployType == 'simple' ]; then
	basic_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $basic_result | awk -F ' ' '{if ($basic_result ~ /[SUCCESS](es)?/) print " 后台""\t\t""\033[32m"$basic_result" \033[0m"; else  print " 后台""\t\t""\033[31m "$basic_result" \033[0m";}' 
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m ============zm_business_video_basic打包成功==================== \033[0m"
fi

cp $basic_webapp_home/zm_business_video_basic_webapp/target/zm_business_video_basic_webapp.war  $TempDir/basic_webapp.war

cd $web_webapp_home

if [ $DeployType == 'simple' ]; then
	web_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $web_result | awk -F ' ' '{if ($web_result ~ /[SUCCESS](es)?/) print " 站点""\t\t""\033[32m"$web_result" \033[0m"; else  print " 站点""\t\t""\033[31m "$web_result" \033[0m";}'
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m ============zm_business_video_web打包成功==================== \033[0m"
fi

cp $web_webapp_home/zm_business_video_web_webapp/target/zm_business_video_web_webapp.war  $TempDir/web_webapp.war

cd $wap_home

if [ $DeployType == 'simple' ]; then
	wap_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $wap_result | awk -F ' ' '{if ($wap_result ~ /[SUCCESS](es)?/) print " 移动""\t\t""\033[32m"$wap_result" \033[0m"; else  print " 移动""\t\t""\033[31m "$wap_result" \033[0m";}'
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m ============zm_business_video_wap打包成功==================== \033[0m"
fi
cp $wap_home/target/zm_business_video_wap.war  $TempDir/web_wap.war


cp $TempDir/basic_webapp.war $video_web_tomcat_apps_home/admin.war
cp $TempDir/web_webapp.war $video_web_tomcat_apps_home/ROOT.war
cp $TempDir/web_wap.war $video_web_tomcat_apps_home/wap.war

if [ $DeployType == 'simple' ]; then
	echo -e "\033[33m  \033[0m"
else
        echo "---------------------finished------------------------------------"
fi


