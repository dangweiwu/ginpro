Api:
  Host: 0.0.0.0:80
  OpenGinLog: true
  ViewDir : ./view

Admin:
  RawPassword: a123456
  InitAdmin: false

Log:
  LogName: ./log/api.log
  Level: debug
  OutType: all
  Formatter: txt

Mysql:
  User: root	
  Password: "123456"
  Host: mysql:3306
  DbName:
  LogFile:
  LogLevel: 1

Redis:
  Addr: redis:6379
  Password:
  Db: 0

Jwt:
  Secret: jwtsecret123#$
  # 过期时间 3天
  Exp: 259200

Prom:
  Username: goserver
  Password: goserver123