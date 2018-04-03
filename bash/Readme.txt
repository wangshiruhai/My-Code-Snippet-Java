[发布api]
/home/admin/bash/deploy-api.sh

[发布service]
/home/admin/bash/deploy-service.sh

[发布web]
/home/admin/bash/deploy-web.sh


--------------------------------
[启动api-webapp]

/home/admin/bash/startup-api.sh

[停止api-webapp]
/home/admin/bash/shutdown-api.sh

--------------------------------

[启动service]
/home/admin/bash/startup-service.sh

[停止service]
/home/admin/bash/shutdown-service.sh

--------------------------------

[启动web]
/home/admin/bash/startup-web.sh

[停止web]
/home/admin/bash/shutdown-web.sh

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
