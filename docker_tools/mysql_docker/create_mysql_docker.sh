#!/usr/bin/env bash
########################################################################
#    File Name: create_mysql_docker.sh
# 
#       Author: lingren Shanghai,Inc.
#         Mail: shuiheng_40@163.com
# Created Time: Wed 04 Dec 2019 02:27:55 PM CST
#  Description: ...
# 
########################################################################
set -u

source ./config.sh

function check_have_mysql_image()
{
    local version=$1
    local nums=`docker images | grep mysql | grep ${version} | wc -l`
    if [ $nums -le 0 ];then
        return 1
    fi
    return 0
}

function install_mysql_image()
{
    local version=$1
    docker pull mysql:${version}
    return $?
}

function check_have_mysql_container()
{
    local version=$1
    local nums=`docker ps -a | grep mysql | grep ${version} | wc -l`
    if [ $nums -le 0 ];then
        return 1
    fi
    return 0
}

function install_mysql_container()
{
    local version=$1
    local source_port=$2
    local target_port=$3
    local log_path=$4
    local data_path=$5
    local conf_path=$6
    local root_passwd=$7
    docker run -p ${target_port}:${source_port} --name mysql-${version} --privileged=true -v ${log_path}:/var/logs/mysql -v ${data_path}:/var/lib/mysql -v ${conf_path}:/etc/mysql/mysql.conf.d/mysqld.cnf -e MYSQL_ROOT_PASSWORD=${root_passwd} -d mysql:${version} && docker restart mysql-${version}
    return $?
}

function get_mysql_container_id()
{
    local version=$1
    local container_id=`docker ps -a | grep mysql | grep ${version} | awk '{print $1}'`
    echo ${container_id}
}

function check_container_is_running()
{
    local container_id=$1
    local nums=`docker container ls | grep ${container_id} | wc -l`
    if [ $nums -le 0 ];then
        return 1
    fi
    return 0
}

function start_container()
{
    local container_id=$1
    local ret=`docker start ${container_id}`
    return $?
}

function stop_container()
{
    local container_id=$1
    local ret=`docker stop ${container_id}`
    return $?
}

check_have_mysql_image ${MYSQL_VERSION}
if [ $? -eq 1 ];then
    echo -e "${GREEN}begin install mysql image${END}"
    install_mysql_image ${MYSQL_VERSION}
    if [ $? -eq 1 ];then
        echo -e "${RED}install mysql image failed!!!${END}"
        exit 1
    fi
    echo -e "${GREEN}end install mysql image${END}"
fi
echo -e "${GREEN}mysql image is installed${END}"

check_have_mysql_container ${MYSQL_VERSION}
if [ $? -eq 1 ];then
    echo -e "${GREEN}begin install mysql container${END}"
    install_mysql_container ${MYSQL_VERSION} ${SOURCE_PORT} ${TARGET_PORT} ${MYSQL_LOG_PATH} ${MYSQL_DATA_PATH} ${MYSQL_CONF_PATH} ${ROOT_PASSWD}
    if [ $? -eq 1 ];then
        echo -e "${RED}install mysql container failed!!!${END}"
        exit 1
    fi
    echo -e "${GREEN}end install mysql container${END}"
fi
echo -e "${GREEN}mysql container is installed${END}"

mysql_container_id=$(get_mysql_container_id ${MYSQL_VERSION})
check_container_is_running ${mysql_container_id}
if [ $? -eq 1 ];then
    echo -e "${GREEN}begin start container:${YELLOW}${mysql_container_id}${END}"
    start_container ${mysql_container_id}
    if [ $? -eq 1 ];then
        echo -e "${RED}container:${YELLOW}${mysql_container_id} start failed!!${END}"
        exit 1
    fi
    echo -e "${GREEN}end start container:${YELLOW}${mysql_container_id}${END}"
fi
echo -e "${GREEN}container:${YELLOW}${mysql_container_id} is running${END}"
echo -e "${GREEN}mysql container is enable!!${END}"
