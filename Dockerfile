# 使用 python:3.10-slim 作为基础镜像
FROM python:3.10-slim

USER root

# 更新包列表并安装 openssh-server 和 git
RUN apt-get update && \
    apt-get install -y openssh-server git sudo && \
    rm -rf /var/lib/apt/lists/*

# 创建 SSH 服务所需的目录
RUN mkdir /var/run/sshd

# 禁止 root 用户通过 SSH 登录
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

# 复制入口脚本到容器中并设置权限
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 暴露 SSH 端口
EXPOSE 22

# 设置环境变量，默认值为空
ENV USER_NAME=""
ENV USER_PASSWORD=""
ENV SSH_PUB=""
ENV GIT_NAME=""
ENV GIT_EMAIL=""
#可选，默认值为空
ENV APT_PACKAGES=""

# 环境变量说明
# USER_NAME: 新用户的用户名 (必须)
# USER_PASSWORD: 新用户的密码 (必须)
# SSH_PUB: 新用户的 SSH 公钥 (必须)
# GIT_NAME: Git 用户的姓名 (必须)
# GIT_EMAIL: Git 用户的邮箱 (必须)
# APT_PACKAGES: 要安装的 APT 软件包，以空格分隔 (可选)

# 设置容器启动时执行的命令
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]