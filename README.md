# App Demo

> 可以说是最完善的 Grape 框架的脚手架

## 概览

不同于 Rails，使用纯 Ruby 构建的脚手架项目，仅使用 Bundler 和 Rack 运行服务器，非常地轻量。

脚手架包含的组件：

- 纯 [Grape](https://github.com/ruby-grape/grape) 实现，完全脱离 Rails
- 支持自动生成 Swagger 文档
- 单元测试
- `rake db:setup`、`rake db:migrate` 等
- ActiveRecord
- [pundit](https://github.com/varvet/pundit)：权限验证
- [overcommit](https://github.com/sds/overcommit) 和 [RuboCop](https://github.com/rubocop-hq/rubocop)：代码质量保证
- 一个类似于 `rails console` 的交互式环境
- ……

## 快速开始

### 依赖

- Ruby: 推荐 2.6.x 版本
- SQLite3 的开发包: 版本不低于 3.8，编译方式可以查看文档[编译和构建 SQLite3](docs/sqlite3-compile.md).

### 准备 overcommit

全局安装：

```bash
gem install overcommit -v 0.52.1
```

初始化一个 Git 仓库（如果已存在 `./.git` 目录请忽略）：

```bash
git init
```

在项目内初始化：

```bash
overcommit --install
```

### 安装 gems

可设置 bundle 命令安装的路径（此步骤亦可忽略）：

```bash
bundle config set path './vendor/bundle'
```

安装 Gems：

```bash
bundle
```

如果是在生产环境，应使用如下命令，它不会安装 development 和 test 环境的 gems：

```bash
bundle --without development test
```

### 准备数据库

首先，确认 `db/schema.rb` 文件是否已创建。如果没有创建，执行如下命令：

```bash
bin/rake db:migrate
bin/rake db:seeds
```

如果已经创建，只需要执行：

```bash
bin/rake db:setup
```

生产环境的正确执行步骤是：

```bash
bin/rake db:create
bin/rake db:schema:load
```

### 运行测试

```bash
bin/test
```

### 启动服务器

```bash
bundle exec rackup -p 9292
```

## 示例项目

为了较完整地演示 grape 框架的能力，项目实现了一套 API 接口，这套接口模拟了博客系统提供的 API 服务：

- 登录

  - `POST /logins`: 登录获取 token

- 用户

  - `GET /users`: 查看所有用户信息
  - `POST /users`: 注册用户
  - `GET /user`: 查看我的信息
  - `PUT /user`: 更新我的信息

- 博文

  - `GET /posts`: 查看我的所有的博文
  - `GET /users/:user_id/posts`: 查看某用户的所有博文
  - `POST /posts`: 创建新博文
  - `GET /posts/:id`: 查看单个博文
  - `PUT /posts/:id`: 更新博文
  - `DELETE /posts/:id`: 删除某博文

## 组件和工程

脚手架内嵌了我认为好用的很多 gems，如 ActiveRecord、pundit 等；并且封装了很多便捷的命令。这些内容，请移步到组件的详细页面：

> [组件](docs/components.md)

另外，由于集成了 overcommit 和 RuboCop，而很多新手对此不太熟悉，特写了一篇针对新手的存活指南：

> [初学者如何在 Overcommit 和 RuboCop 下生存下来](docs/overcommit-and-rubocop)

## Windows 兼容性

本脚手架只在 Linux 环境下得到测试，Mac 和 Windows 环境并未全面测过。Mac 与 Linux 同属于 Unix 环境，上手应该很直接。而 Windows 下恐怕要做较大改动才可完整使用。

兼容性要考虑到以下几个问题：

1. 项目代码如何运行，这包括 gems 的安装、服务器的启动等？
2. bin 目录下的命令如何运行？
3. overcommit 中的命令如何运行？

对于一个常年在 Windows 环境下捯饬 Ruby 的开发者来说，问题 1 应该不是问题。如果这成为问题，那应该考虑更换 Ruby 开发的环境，如 Linux.

主要的问题在于 bin 目录下的脚本和 overcommit 中的自动化命令，这些我都是以 Linux 的 Bash 环境为参照编写的。但只要阅读其中的代码和配置，改写为 Windows 下的形式，也就 ok 了。脚本的命令大部分都很简单，很容易就能提取出 Windows 下的调用方式。

## 参考资料

- [How to manage application dependencies with Bundler](https://bundler.io/guides/using_bundler_in_applications.html)
