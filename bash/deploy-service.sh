#author 张国伟
#last update 2017-10-23

#!/bin/sh
export LANG=zh_CN.UTF-8

read -p " 请输入将要部署模式(例如:simple|normal): " DeployType

DeployType=${DeployType:-simple}
echo " 启动模式:" $DeployType

Version="1.0" #发布版本号
UserName="admin" #系统运行用户
TempDir="/home/"$UserName"/deploy/Temp/" #临时目录

source_code_base_home="/home/"$UserName"/deploy/JavaCode" #源代码根目录

basic_service_home=$source_code_base_home/zm_business_video_basic_core  #basic service 源代码目录 管理系统后台模块
web_service_home=$source_code_base_home/zm_business_video_web_core  #web service 源代码目录  web站点模块
cache_service_home=$source_code_base_home/zm_business_cache_core  #cache service 源代码根目录   缓存模块
work_service_home=$source_code_base_home/zm_business_video_work_core  #video workcd  service 源代码根目录 视频加工模块
video_util_home=$source_code_base_home/zm_business_video_util   #video util  视频共工类

tomcat_service_apps_home="/home/"$UserName"/tomcat/instance/service/webapps" #basic_service部署目录




if [ $DeployType == 'simple' ]; then
        pre_result=`echo -e "\033[33m 正在打包部署 \033[0m"`
	echo -e $pre_result "\033[5m...... \033[0m" 
        cd $source_code_base_home
        svn update > /dev/null 2>&1 

	echo -e '\n'
	echo 0 | awk -F ' ' '{print " 名称\t\t\t打包结果";print "-------------------------------";}' 
else
	echo -e "\033[33m ======================开始更新代码========================== \033[0m"
	cd $source_code_base_home
        svn update
        echo -e "\033[33m ======================更新代码完成========================== \033[0m"
        echo -e '\n\n\n'
        echo -e "\033[33m ======================正在执行打包========================== \033[0m"
fi

#视频公共类 打包
cd $video_util_home
if [ $DeployType == 'simple' ]; then
        util_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
        echo $util_result | awk -F ' ' '{if ($util_result ~ /[SUCCESS](es)?/) print " 公共方法""\t\t""\033[32m"$util_result" \033[0m"; else  print " 公共方法""\t\t""\033[31m "$util_result" \033[0m";}'
else
        mvn clean install -Dmaven.test.skip=true
        echo -e "\033[33m ============zm_business_video_util打包成功==================== \033[0m"
fi



cd $basic_service_home

if [ $DeployType == 'simple' ]; then
	basic_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $basic_result | awk -F ' ' '{if ($basic_result ~ /[SUCCESS](es)?/) print " 族蚂后台""\t\t""\033[32m"$basic_result" \033[0m"; else  print " 族蚂后台""\t\t""\033[31m "$basic_result" \033[0m";}' 
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m ============zm_business_video_basic打包成功==================== \033[0m"
fi

cp $basic_service_home/zm_business_video_basic_service/target/zm_business_video_basic_service.war  $TempDir/zm_business_video_basic_service.war

#接口代码切换至employee数据源
cp $web_service_home/zm_business_video_web_service/src/main/resources/dataSource/application_root_employee.xml $web_service_home/zm_business_video_web_service/src/main/resources/application-root.xml

cd $web_service_home

if [ $DeployType == 'simple' ]; then
	web_emp_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $web_emp_result | awk -F ' ' '{if ($web_emp_result ~ /[SUCCESS](es)?/) print " 员工站点""\t\t""\033[32m"$web_emp_result" \033[0m"; else  print " 员工站点""\t\t""\033[31m "$web_emp_result" \033[0m";}' 
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m =================employee service打包成功======================== \033[0m"
fi

cp $web_service_home/zm_business_video_web_service/target/zm_business_video_web_service.war  $TempDir/zm_business_video_web_service_employee.war
#employee接口包文件收集完成

#接口代码切换至member数据源
cp $web_service_home/zm_business_video_web_service/src/main/resources/dataSource/application_root_member.xml $web_service_home/zm_business_video_web_service/src/main/resources/application-root.xml

if [ $DeployType == 'simple' ]; then
	web_mem_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $web_mem_result | awk -F ' ' '{if ($web_mem_result ~ /[SUCCESS](es)?/) print " 会员站点""\t\t""\033[32m"$web_mem_result" \033[0m"; else  print " 会员站点""\t\t""\033[31m "$web_mem_result" \033[0m";}' 
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m =================member接口打包成功========================== \033[0m"
fi

cp $web_service_home/zm_business_video_web_service/target/zm_business_video_web_service.war $TempDir/zm_business_video_web_service_member.war
#member接口包文件收集完成

cd $cache_service_home

if [ $DeployType == 'simple' ]; then
	cache_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $cache_result | awk -F ' ' '{if ($cache_result ~ /[SUCCESS](es)?/) print " 缓存服务""\t\t""\033[32m"$cache_result" \033[0m"; else  print " 缓存服务""\t\t""\033[31m "$cache_result" \033[0m";}' 
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m =================cache service打包成功======================== \033[0m"
fi

cp $cache_service_home/zm_business_cache_service/target/zm_business_cache_service.war $TempDir/zm_business_cache_service.war
#cache接口包文件收集完成

cd $work_service_home

if [ $DeployType == 'simple' ]; then
	work_result=`mvn clean install -Dmaven.test.skip=true |sed -n '/BUILD /,+0p' |awk -F  'BUILD ' '{print $2}'`
	echo $work_result | awk -F ' ' '{if ($work_result ~ /[SUCCESS](es)?/) print " 视频加工""\t\t""\033[32m"$work_result" \033[0m"; else  print " 视频加工""\t\t""\033[31m "$work_result" \033[0m";}' 
else
	mvn clean install -Dmaven.test.skip=true
	echo -e "\033[33m =================videowork service打包成功======================== \033[0m"
fi

cp $work_service_home/zm_business_video_work_service/target/zm_business_video_work_service.war $TempDir/zm_business_video_work_service.war
cp $TempDir/zm_business_video_basic_service.war $tomcat_service_apps_home/zm_business_video_basic_service-$Version.war
cp $TempDir/zm_business_video_web_service_employee.war $tomcat_service_apps_home/zm_business_video_web_service_employee-$Version.war
cp $TempDir/zm_business_video_web_service_member.war $tomcat_service_apps_home/zm_business_video_web_service_member-$Version.war
cp $TempDir/zm_business_cache_service.war $tomcat_service_apps_home/zm_business_cache_service-$Version.war
cp $TempDir/zm_business_video_work_service.war $tomcat_service_apps_home/zm_business_video_work_service-$Version.war

if [ $DeployType == 'simple' ]; then
	echo -e "\033[33m  \033[0m"  #关闭echo转义
else
        echo "---------------------finished----------------------------------------------"
	echo -e '\n\n\n'
	echo -e "\033[33m "=============================================================" \033[0m"
	echo -e "\033[33m "================视频服务模块发布完成！=======================" \033[0m"
	echo -e "\033[33m "=============================================================" \033[0m"
fi

