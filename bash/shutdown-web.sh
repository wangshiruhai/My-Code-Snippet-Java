#!/bin/bash

export CATALINA_BASE="/home/admin/tomcat/instance/web"

export CATALINA_HOME="/home/admin/tomcat/tomcat-8.5.5"
export JRE_HOME="/home/admin/tomcat/jdk1.8.0_131/jre"

export CATALINA_TMPDIR="$CATALINA_BASE/temp"
export CATALINA_PID="$CATALINA_BASE/tomcat.pid"
 
bash $CATALINA_HOME/bin/shutdown.sh "$@"
