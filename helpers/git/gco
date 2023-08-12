#/bin/bash

function gco(){
    if [ -z $1 ];then
        read -p "Comment:" comment
        echo ""
    else
        comment=$1
    fi

    git commit -m "$comment"

}

gco $1