#!/usr/bin/env bash
########################################################################
#    File Name: config.sh
# 
#       Author: lingren Shanghai,Inc.
#         Mail: shuiheng_40@163.com
# Created Time: Wed 04 Dec 2019 02:14:02 PM CST
#  Description: ...
# 
########################################################################
set -u

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
GRAY="\033[0;37m"
LIGHT_RED="\033[1;31m"
LIGHT_YELLOW="\033[1;33m"
LIGHT_GREEN="\033[1;32m"
LIGHT_BLUE="\033[0;34m"
LIGHT_GRAY="\033[1;37m"
END="\033[0;00m"

#MYSQL的版本
MYSQL_VERSION=5.7

#ROOT用户的密码
ROOT_PASSWD=123

#新建用户的信息
NEW_USER=saier
NEW_USER_PASSWD=123

SOURCE_PORT=3306
#映射的宿主机目标端口
TARGET_PORT=3306

MYSQL_LOG_PATH=/data/mysql/logs

MYSQL_DATA_PATH=/data/mysql/data

MYSQL_CONF_PATH=/home/lori/selfcode/oschina/shell_util/docker_tools/mysql_docker/my_docker.cnf
