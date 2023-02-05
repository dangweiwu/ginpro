version: '3'

vars:
    coverout: "cover.out"
    htmlout: "cover.html"
    covercount: 70
tasks:
  # 测试
  test:
    cmds:
      - go install github.com/jstemmer/go-junit-report@latest

      - go test -cover -v
        -coverprofile="{{.coverout}}"
        -coverpkg={{.pkgs}}
        ./... | go-junit-report --set-exit-code > report.xml

      - sed -i '/\/cmd\/server.go/d' {{.coverout}}

      - go tool cover -html={{.coverout}} -o {{.htmlout}}

      - go tool cover -func={{.coverout}} | grep 'total:' | gawk -v target={{.covercount}} -f ./script/cover.awk

    vars:
      pkgs:
        sh: go list ./... |grep 'api' | grep -v 'api_test'| tr '\n' ',' | sed 's/.$//g'
  # 文档
  swag:
    - go install github.com/swaggo/swag/cmd/swag@latest
    - swag fmt
    - swag init --pd --parseInternal -o doc/swag


