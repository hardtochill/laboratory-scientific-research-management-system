# 实验室科研管理系统

一个面向高校实验室的科研管理平台，支持任务管理、文献管理、投稿管理、审核管理等核心业务流程，采用前后端分离架构开发。

## 技术栈

### 前端

| 技术 | 版本 | 说明 |
|---|---|---|
| Vue.js | 3.5 | 渐进式 JavaScript 框架 |
| Vite | 6.3 | 前端构建工具 |
| Element Plus | 2.9 | Vue 3 UI 组件库 |
| Pinia | 3.0 | Vue 状态管理 |
| Vue Router | 4.5 | 前端路由 |
| Axios | 1.9 | HTTP 请求库 |
| ECharts | 5.6 | 数据可视化图表 |
| Sass | - | CSS 预处理器 |

### 后端

| 技术 | 版本 | 说明 |
|---|---|---|
| Spring Boot | 2.5.15 | Java 应用框架 |
| JDK | 1.8 | Java 运行环境 |
| Spring Security | 5.7 | 安全认证框架 |
| MyBatis-Plus | 3.5.1 | ORM 持久层框架 |
| MySQL | - | 关系型数据库 |
| Redis | - | 缓存中间件 |
| Druid | 1.2 | 数据库连接池 |
| JWT | 0.9 | Token 认证 |
| Quartz | - | 定时任务调度 |
| Swagger | 3.0 | API 文档 |
| Lombok | 1.18 | Java 代码简化工具 |

## 项目结构

```
laboratory-scientific-research-management-system/
├── backend/                          # 后端
│   ├── java/                         # Spring Boot 工程
│   │   ├── src/main/java/com/ruoyi/  # 源代码
│   │   ├── src/main/resources/       # 配置文件
│   │   └── pom.xml                   # Maven 依赖管理
│   └── file/                         # 文件存储目录
├── front/                            # 前端
│   └── web/                          # Vue 3 工程
│       ├── src/                      # 源代码
│       │   ├── views/                # 页面组件
│       │   ├── api/                  # 接口定义
│       │   └── ...
│       ├── vite.config.js            # Vite 配置
│       └── package.json              # 依赖管理
└── readME.md
```

## 功能模块

| 模块 | 说明 |
|---|---|
| 登录首页 | JWT 认证登录、数学验证码、首页数据看板 |
| 任务管理 | 多级子任务树形管理、进度自动计算、状态流转、定时汇报 |
| 文献管理 | 文献上传与共享、多维度加权评分、两级评论体系、阅读统计导出 |
| 投稿管理 | 投稿计划管理、多轮投稿流程、文件标签分类 |
| 审核管理 | 师生双重审核、审核流程自动流转、时间线展示 |
| 系统管理 | 用户管理、角色管理、菜单权限配置 |

## 环境准备

- JDK 1.8+
- Node.js 16+
- MySQL 5.7+
- Redis 5.0+
- Maven 3.6+

## 快速开始

### 1. 数据库初始化

创建 MySQL 数据库 `experiment_management`，导入初始化 SQL 脚本。

### 2. 后端启动

```bash
cd backend/java

# 修改 src/main/resources/application-dev.yml 中的数据库和 Redis 连接信息

# Maven 构建并运行
mvn spring-boot:run

# 或打包后运行
mvn clean package
java -jar target/buct-tech.jar
```

后端默认启动在 `http://localhost:8080`。

### 3. 前端启动

```bash
cd front/web

# 安装依赖
npm install

# 开发模式启动
npm run dev

# 生产环境构建
npm run build:prod
```

前端开发服务器默认启动在 `http://localhost:81`，API 请求自动代理至后端 8080 端口。

## 端口说明

| 服务 | 端口 | 说明 |
|---|---|---|
| 前端开发服务器 | 81 | Vite dev server |
| 后端应用 | 8080 | Spring Boot |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |


