#/bin/bash

function gb(){
    if [ -z $1 ];then
        git branch --show-current
    else
        git branch $1
    fi
}

function gs(){
    git status $1
}

function gf(){
    git fetch origin
}

function gpl(){
    branch=$(git branch --show-current)
    git pull origin $branch
}

function gps(){
    branch=$(git branch --show-current)
    git push origin $branch
}

function ga(){
    if [ -z $1 ];then
        git add .
    else
        git add $1
    fi
}

function gc(){
    git status
    read -s -p "Target path:" path

    git add $path

    read -s -p "Comment:" comment
    git commit -m "$comment"

    branch=$(git branch --show-current)
    git push origin $branch
}

