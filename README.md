<h1 align="center">Gin Pro</h1>
<p align="center">
<img alt="Static Badge" src="https://img.shields.io/badge/Go- 1.9-blue">
<img alt="Static Badge" src="https://img.shields.io/badge/Gin- 1.8-blue">

<img alt="Static Badge" src="https://img.shields.io/badge/Vue- 3.x -gren">
<img alt="Static Badge" src="https://img.shields.io/badge/Arco- 2.34.0 -gren">
<img alt="Static Badge" src="https://img.shields.io/badge/license- MIT-blue">

</p>

_面向开发者的API快速开发框架_

---
## 特点：
- 项目通过模板代码生成实现，包括中间件，功能函数等，方便功能定制。
- 模板项目包括基础api框架，admin框架(前后端)，带权限的api框架(前后端)。
- 自带可观测性解决方案，日志、追踪、指标。
- 自带文档解决方案，方便的文档交流。
- 经过时间与项目的洗礼。
---
### 使用说明:
```
go install github.com/dangweiwu/ginpro
```

安装完毕后运行:

```
ginpro -h 查看使用说明
```
其命令包括:
```
Available commands:
  admin          生成后端admin server框架
  adminauth      生成后端admin auth server框架
  apitpl         生成后端api模板
  htmladmin      生成前端admin框架
  htmladminauth  生成前端admin框架
  htmlapi        生成前端api html模板
  server         生成后端基础server框架
```
eg:
生成一个项目，名为demo。
```
ginpro admin demo

```
你将看到如下提示:
```
admin项目初始化完成
please run:

cd demo &&
go mod init demo &&
go mod tidy &&
go work use .
```
*果如你没有在使用go work空间，请移除最后一条命令`go work use .`*

说明:

1. `server` 基础框架。包括：
   - 配置
   - 日志(log)
   - 路由系统
   - response统一格式化处理
   - 分页组件
   - 路由追踪(trace)
   - 指标(metric)
   
2. `admin` 生成后端admin server框架,在`server`框架基础上添加admin管理。
3. `htmladmin` `admin`配套前端vue框架,基于`Arco`
4. `adminauth` 生成后端 admin auth server框架,在`admin`基础上添加权限管理及中间件。
5. `htmladminauth` `htmladmin`配套前端宽假
6. `apitpl` 生成api基础代码，包括增删查改及路由代码，生成代码如不合适，可直接在生成后的代码里进行修改。
7. `htmlapi` 生成前端api相对应的api代码，包括增删查改，需要在代码里进行少量编写，包括路由及具体的form表单。

---
### 其他
1. 本项目支持完整的可观测性，包括日志(log)，追踪(trace)，指标(metric)。方案基于[openobserve](https://openobserve.ai/),其中日志采集及指标采集都是基于go编写的采集工具，具有使用简单、可靠，与微服务的ELK相比，该方案使用资源极少。
2. 本项目快速开发基于代码生成理念，生成的代码不会是最终代码，但一定是最常用的代码部分。而最常用的代码并没有封装成组件提供使用，而是直接生成在项目里，这是为了修改方便，同时使整个项目逻辑简单，一看就懂。

---
### License
© Dangweiwu, 2023~time.Now

Released under the MIT License