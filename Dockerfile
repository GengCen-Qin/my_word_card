# 使用基于Ruby的Docker镜像作为基础镜像
FROM ruby:3.2.2

# 安装所需的系统依赖
RUN apt-get update \
    && apt-get install -y sqlite3 libsqlite3-dev redis esbuild \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 将Gemfile和Gemfile.lock复制到容器中
COPY Gemfile Gemfile.lock ./

# 安装项目所需的Gem依赖
RUN gem install bundler \
    && bundle install --jobs 4 --retry 4

# 将项目所有文件复制到容器中
COPY . .

# 运行数据库迁移
RUN bundle exec rake db:migrate

# 启动Redis服务器并绑定到特定端口
RUN redis-server --daemonize yes --bind 0.0.0.0 --port 6379

# 暴露Rails服务器端口
EXPOSE 3000

# 启动Rails服务器
CMD redis-server --daemonize yes && bundle exec rails server -b 0.0.0.0