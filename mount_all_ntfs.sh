#!/bin/bash

#····································
# Intro : 挂载你的 NTFS 格式硬盘    ·
#-----------------------------------·
# Author: Traces                    ·
#-----------------------------------·
# Date  : 2021/7/19                 ·
#--------------------------------····
# Github: https://github.com/Traced ·
#····································


# 指定了这个 flag 在挂载完成后会自动打开磁盘
openFlag="--open"

# 0 不打印过程 1  打印
isLogger=1

log(){
    if [ $isLogger == 1  ]; 
    then
        echo $1
    fi
}

mount | grep ntfs | while read line
do
    df=(`echo $line | awk '{printf ("%s %s",$1,$3)}'`)
    log "将${df[1]}挂载成可读写模式"
    sudo umount ${df[0]}
    log "创建挂载文件夹：${df[1]}"
    sudo mkdir ${df[1]}
    log "请稍候，正在进行${df[0]}的挂载工作, 请勿断开链接。"
    sudo mount_ntfs -o rw,nobrowse ${df[*]}
    log "${df[0]} => ${df[1]}"
    log "读写模式挂载完毕!"
    # 如果指定了打开的标识符
    if [ -n "$1" ] && [ $1 == $openFlag ]
    then 
        log " 由于你指定了$openFlag, 即将打开 ${df[1]}";
        open ${df[1]};
    fi
done
