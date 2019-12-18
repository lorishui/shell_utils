#!/usr/bin/env bash
########################################################################
#    File Name: create_mysql_user.sh
# 
#       Author: lingren Shanghai,Inc.
#         Mail: shuiheng_40@163.com
# Created Time: Wed 18 Dec 2019 08:25:08 PM CST
#  Description: ...
# 
########################################################################
set -u

source ./config.sh

function create_new_user()
{
    local version=$1
    local root_passwd=$2
    local new_user=$3
    local new_user_passwd=$4
    docker exec mysql-${version} mysql -e "grant all on *.* to '${new_user}'@'%' identified by '${new_user_passwd}'"
    docker exec mysql-${version} mysql -e "flush privileges;"
    return $?
}
echo -e "${GREEN}create mysql user:${YELLOW}${NEW_USER}${GREEN}?${YELLOW}Y/N(N)${END}"
read choice
if [ "${choice}" = "Y" ] || [ "${choice}" = "y" ];then
    echo -e "${GREEN}begin create mysql user..${END}"
    create_new_user ${MYSQL_VERSION} ${ROOT_PASSWD} ${NEW_USER} ${NEW_USER_PASSWD}
    echo -e "${GREEN}end create mysql user..${END}"
    echo -e "${GREEN}create mysql user success${END}"
else
    echo -e "${RED}cancel create mysql user!!${END}"
fi

