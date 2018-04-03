#!/bin/bash

export CATALINA_BASE="/home/admin/tomcat/instance/api"

export CATALINA_HOME="/home/admin/tomcat/tomcat-8.5.5"
export JRE_HOME="/home/admin/tomcat/jdk1.8.0_131/jre"

export CATALINA_TMPDIR="$CATALINA_BASE/temp"
export CATALINA_PID="$CATALINA_BASE/tomcat.pid"
export JAVA_OPTS="-server -Xms1024m -Xmx2048m -Djava.awt.headless=true -Dtomcat.name=api"
  
# 调用tomcat启动脚本
bash $CATALINA_HOME/bin/startup.sh "$@"
