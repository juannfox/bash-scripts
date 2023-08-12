#/bin/bash

if [ -z $1 ];then
    echo "Enter path to your RC file as arg \$1."
    exit 1
fi
if [ -z $2 ];then
    echo "Enter path to your helper scripts folder as arg \$2."
    exit 1
fi

rc_path=$1
script_path=$2

echo "" >>  $rc_path
echo "# JIF helpers" >>  $rc_path
echo "export PATH=\$PATH:$script_path" >> $rc_path

export PATH=$PATH:$script_path

chmod +x $script_path/*

echo "Added $2 as part of PATH in $1."