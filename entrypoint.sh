#!/bin/bash

# 从环境变量中获取参数
USER_NAME=${USER_NAME}
USER_PASSWORD=${USER_PASSWORD}
SSH_PUB=${SSH_PUB}
GIT_NAME=${GIT_NAME}
GIT_EMAIL=${GIT_EMAIL}
APT_PACKAGES=${APT_PACKAGES}

# 检查必需的环境变量是否设置
if [ -z "${USER_NAME}" ]; then
    echo "Error: USER_NAME is required."
    exit 1
fi

if [ -z "${USER_PASSWORD}" ]; then
    echo "Error: USER_PASSWORD is required."
    exit 1
fi

if [ -z "${SSH_PUB}" ]; then
    echo "Error: SSH_PUB is required."
    exit 1
fi

if [ -z "${GIT_NAME}" ]; then
    echo "Error: GIT_NAME is required."
    exit 1
fi

if [ -z "${GIT_EMAIL}" ]; then
    echo "Error: GIT_EMAIL is required."
    exit 1
fi

# 创建新用户并设置密码
useradd -m -s /bin/bash ${USER_NAME}
echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# 将用户加入 sudo 用户组
usermod -aG sudo ${USER_NAME}

# 创建 .ssh 目录并设置权限
mkdir -p /home/${USER_NAME}/.ssh
echo "${SSH_PUB}" >> /home/${USER_NAME}/.ssh/authorized_keys
chmod 600 /home/${USER_NAME}/.ssh/authorized_keys
chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.ssh

# 配置 git
sudo -u ${USER_NAME} git config --global user.name "${GIT_NAME}"
sudo -u ${USER_NAME} git config --global user.email "${GIT_EMAIL}"

# 安装 APT 包
if [ -n "${APT_PACKAGES}" ]; then
    echo "Installing APT packages: ${APT_PACKAGES}"
    apt-get update && apt-get install -y ${APT_PACKAGES}
fi

# 启动 SSH 服务
exec /usr/sbin/sshd -D