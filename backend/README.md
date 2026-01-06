# 智慧校园外卖服务平台

本项目是基于 Spring Boot 3 + Vue 3 开发的一站式智慧校园餐饮服务平台。

## 目录结构说明

- `project-sky-admin-vue-ts`: Web 端管理后台
- `mp-weixin`: 微信小程序
- `sky-server`: 后端服务
- `mysql.sql`: 数据库初始化脚本

## 技术栈

- 后端框架
  - SpringBoot 3.1.2
  - MyBatis
- 数据库
  - MySql 8.0
  - Redis
- 前端框架
  - Vue 3
  - Uniapp
  - Element Plus
- 前后端通信
  - RESTful API

## Windows 开发环境搭建

1. 安装 Java JDK 17 并配置环境变量
2. 安装 MySQL、Redis 并创建相应数据库 

   - 创建 MySQL 数据库与表: 运行 [mysql.sql](./demo/mysql.sql)

3. 安装 Maven 构建工具

4. 克隆项目到本地

5. 修改配置文件 [application.yml](./sky-server/src/main/resources/application.yml)

   ```yml
   spring:
     datasource:
       url: jdbc:mysql://url
       username: root
       password: mysql密码
     data:
       redis:
         password: redis密码
   ```

6. 在 [resources](./sky-server/src/main/resources/) 目录下新建 `application-env.yml` 文件，写入以下配置

   ```yml
   sky:
     wechat:
       appid: 申请微信小程序可获得
       secret: 申请微信小程序可获得
       mchid: 商户号
       mchSerialNo:
       privateKeyFilePath:
       apiV3Key:
       weChatPayCertFilePath:
       notifyUrl:
       refundNotifyUrl:
   ```

7. 运行项目

- 后端：用 IDEA 打开 sky-server 模块，直接运行 SkyApplication.java 
- 前端：进入前端目录(project-sky-admin-vue-ts)，先执行 npm install 装依赖，再 npm run serve
