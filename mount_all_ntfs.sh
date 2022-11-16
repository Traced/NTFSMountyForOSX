#!/bin/bash

#····································
# Intro : Mount your NTFS formatted hard drive
#-----------------------------------·
# Author: Traces                    ·
#-----------------------------------·
# Date  : 2021/7/19                 ·
#--------------------------------····
# Github: https://github.com/Traced ·
#····································


# Specify this flag to automatically open the disk after the mount is complete
openFlag="--open"

# 0 do not print process 1 print
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
    log "Mount ${df[1]} in read-write mode"
    sudo umount ${df[0]}
    log "Create mount folder: ${df[1]}"
    sudo mkdir ${df[1]}
    log "Please wait, ${df[0]} is being mounted, please do not disconnect."
    sudo mount_ntfs -o rw,nobrowse ${df[*]}
    log "${df[0]} => ${df[1]}"
    log "The read-write mode is mounted!"
    # If an open identifier is specified
    if [ -n "$1" ] && [ $1 == $openFlag ]
    then 
        log "Since you specified $openFlag, ${df[1]} is about to be opened";
        open ${df[1]};
    fi
done
