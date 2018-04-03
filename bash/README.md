### 发布脚本包含三个模块：
* api[提供对其它部门的统一接口]
* service[dubbo 服务组件]
* webapp[提供前台服务对接接口]

整体架构：
brower-->DNS-->Nginx-->应用服务器-->DB
                           |       |
                          Cache-----

| 1          |    2  | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
| brower ------- dns------nginx-----应用服务器------DB------- |


[部署api]
bash/deploy-api.sh

[部署service]
bash/deploy-service.sh

[部署web]
bash/deploy-web.sh


--------------------------------
[启动api-webapp]
bash/startup-api.sh

[停止api-webapp]
bash/shutdown-api.sh

--------------------------------

[启动service]
bash/startup-service.sh

[停止service]
bash/shutdown-service.sh

--------------------------------

[启动web]
bash/startup-web.sh

[停止web]
bash/shutdown-web.sh

------------------------------

[端口使用情况]
8009 service AJP
8092 service http
8005 service shutdown

8109 web AJP
8091 web http
19196 web socket
8105 web shutdown

8093 api-webapp HTTP
8209 api-webapp AJP
8094 api-webapp socket
8205 api-webapp shutdown
