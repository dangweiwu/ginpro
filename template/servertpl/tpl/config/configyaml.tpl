Api:
  Host: "localhost:8001"
  OpenGinLog: true
  ViewDir: ./view

Log:
  LogName: ./log/{{.Module}}.log
  Level: debug
  OutType: all
  Formatter: txt
