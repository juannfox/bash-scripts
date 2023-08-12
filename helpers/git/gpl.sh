#/bin/bash

function gpl(){
    branch=$(git branch --show-current)
    git pull origin $branch
}

gpl
