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
        -coverpkg={{.pkgs}}{{.adminpkg}},{{.cmdpkg}}
        ./... | go-junit-report --set-exit-code > report.xml

      - sed -i '/\/cmd\/server.go/d' {{.coverout}}

      - go tool cover -html={{.coverout}} -o {{.htmlout}}

      - go tool cover -func={{.coverout}} | grep 'total:' | gawk -v target={{.covercount}} -f ./script/cover.awk

    vars:
      pkgs:
        sh: go list ./... | grep 'api' | tr '\n' ','
      adminpkg:
        sh: go list ./... | grep 'adminmock'
      cmdpkg:
        sh: go list ./... | grep 'cmd'
  # 文档
  swag:
    - go install github.com/swaggo/swag/cmd/swag@latest
    - swag init --pd --parseInternal -o doc/swag


