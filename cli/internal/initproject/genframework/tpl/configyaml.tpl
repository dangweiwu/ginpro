Api:
  Host: "localhost:8001"
  OpenGinLog: true

Log:
  LogName: ./log/{{.Module}}.log
  Level: debug
  OutType: all
  Formatter: txt
	
Mysql:
  User: root	
  Password: 123456
  Host: mysql:3306
  DbName: {{.Module}}
