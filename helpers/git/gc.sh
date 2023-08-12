#/bin/bash

function gc(){
    git status
    read -p "Target path (intro to skip):" path
    echo ""

    if [ -z $path ];then
        path="."
    fi

    git add $path

    read -p "Comment:" comment
    echo ""
    git commit -m "$comment"

    branch=$(git branch --show-current)
    git push origin $branch
}

gc