App:
    Name: {{.Module}}
    Password: '123456'

Api:
  Host: 0.0.0.0:80
  OpenGinLog: true
  ViewDir : ./view

Log:
  LogName: ./log/api.log
  Level: debug
  OutType: all
  Formatter: txt

Mysql:
  User: root
  Password: "123456"
  Host: localhost:8306
  DbName: demosys
  LogFile:
  LogLevel: 4

Redis:
  Addr: localhost:8379
  Password: a123456
  Db: 0

Jwt:
  Secret: jwtsecret123#$
  # 过期时间 3天
  Exp: 259200

Prom:
  Enable: true
  Username: goserver
  Password: goserver123

Trace:
  Enable:   false
  Endpoint: ""
  UrlPath:  ""
  Auth:     ""