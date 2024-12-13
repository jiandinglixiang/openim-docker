#!/bin/bash

# 定义函数来处理每个 git pull 操作
function update_git_repo {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo "Error: Directory $dir does not exist."
        exit 1
    fi

    cd "$dir" || exit 1
    echo "Pulling latest changes from $dir..."
    git pull origin main # 或者你使用的默认分支名
    if [ $? -ne 0 ]; then
        echo "Error: Failed to pull updates from $dir."
        exit 1
    fi
}

# 更新 /home/server 中的代码
update_git_repo "/home/openim-server"

# 更新 /home/chat 中的代码
update_git_repo "/home/openim-chat"

# 更新 /home/docker 中的代码
update_git_repo "/home/openim-docker"

# 执行 docker-compose up -d
cd "/home/openim-docker" || exit 1
echo "Starting or updating Docker containers..."
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "Error: Failed to start or update Docker containers."
    exit 1
else
    echo "Docker containers started or updated successfully."
fi