#!/bin/bash

export CATALINA_BASE="/home/admin/tomcat/instance/web"

export CATALINA_HOME="/home/admin/tomcat/tomcat-8.5.5"
export JRE_HOME="/home/admin/tomcat/jdk1.8.0_131/jre"

export CATALINA_TMPDIR="$CATALINA_BASE/temp"
export CATALINA_PID="$CATALINA_BASE/tomcat.pid"
export JAVA_OPTS="-server -Xms4096m -Xmx4096m -Xmn1500m -XX:PermSize=128m -XX:MaxPermSize=256m  -XX:MaxTenuringThreshold=10  -Djava.awt.headless=true -Dtomcat.name=web -XX:CICompilerCount=4 -XX:+PrintGCDetails -XX:+PrintGCDateStamps  -Xloggc:/home/admin/logs/gc_web.log"
  
# 调用tomcat启动脚本
bash $CATALINA_HOME/bin/startup.sh "$@"
