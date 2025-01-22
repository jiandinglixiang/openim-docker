#!/bin/bash

# 定义函数来处理每个 git pull 操作
function update_git_repo {
    local dir=$1
    local branch=$2
    if [ -z "$dir" ] || [ -z "$branch" ]; then
        echo "Error: Directory or branch name not provided."
        exit 1
    fi

    if [ ! -d "$dir" ]; then
        echo "Error: Directory $dir does not exist."
        exit 1
    fi

    cd "$dir" || exit 1
    echo "Pulling latest changes from $dir on branch $branch..."
    git pull origin "$branch"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to pull updates from $dir on branch $branch."
        exit 1
    fi
}

# 更新 /home/server 中的代码，指定分支为 'release'
update_git_repo "/home/openim-server" "release-v3.8.3"

# 更新 /home/chat 中的代码，指定分支为 'release'
update_git_repo "/home/openim-chat" "release-v1.8.4"

# 更新 /home/docker 中的代码，指定分支为 'custom'
update_git_repo "/home/openim-docker" "custom"

# 执行 docker-compose up -d
cd "/home/openim-docker" || exit 1
docker compose down
echo "Starting or updating Docker containers..."
docker compose up -d
if [ $? -ne 0 ]; then
    echo "Error: Failed to start or update Docker containers."
    exit 1
else
    echo "Docker containers started or updated successfully."
fi