#!/bin/bash

declare -A dic
dic=([25]="advert_pos 0; #广告插入的位置, 0为后, 1为前;"  \
     [26]="advert_path /usr/local/guanggao/mov; #广告路径，放入广告m3u8及相关的ts文件"  \
     [27]="advert_num  2; #广告个数，广告命名为数据，如0.ts,1.ts...."  \
     [28]="live_advert_time "  \
     [31]="location ~ \.ts$ {"  \
     [32]="advert_ts;"  \
     [33]="}" )

keys=${!dic[*]}
#echo $keys
fun1(){
    for key in $keys
    do
        if [[ $key == 28 ]]; then
            line="    $1${dic[$key]} $time ; #广告间隔时间(单位：秒);"
        else
            line="    $1${dic[$key]}"
        fi
        #echo "${line}"
        sed -i -e "${key}c\ $line" /etc/nginx/conf.d/live.conf
     done
}

NowAdtime=$(cat /etc/nginx/conf.d/live.conf | grep live_advert_time)
echo ${NowAdtime}

echo -e "\033[31m -q 退出 -p 改变广告时间 -e 停止服务器 -n 不插入广告\033[0m"
read choice
case $choice in
    q)
    exit
    ;;
    p)
    echo -e "\033[31m 隔多少时间播放一次广告: \033[0m"
    read time
    if [[ $time =~ ^[0-9]*[1-9][0-9]*$ ]]; then
        fun1 " "
        /etc/init.d/nginx restart
    else
       echo -e "\033[31m 输入值错误 \033[0m"
       exit
    fi
    ;;
    e)
        /bin/bash /scripts/ad/nginxstop.sh
    ;;
    n)
        fun1 "#"
        /etc/init.d/nginx restart
    ;;
esac

