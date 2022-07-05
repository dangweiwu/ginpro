Api:
  Host: 0.0.0.0:80
  OpenGinLog: true

Log:
  LogName: ./log/dwsy.log
  Level: debug
  OutType: all
  Formatter: txt

Mysql:
  User: root	
  Password: "123456"
  Host: mysql:3306
  DbName: dwsy

Redis:
  Addr: redis:6379
  Password:
  Db: 0

Jwt:
  Secret: dwsy20220702@#
  # 过期时间 3天
  Exp: 259200