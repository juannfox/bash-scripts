#/bin/bash

function gb(){
    if [ -z $1 ];then
        git branch --show-current
    else
        git branch $1
    fi
}

gb $1