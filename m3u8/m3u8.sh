#!/bin/bash
#这个脚本用来测试流
#检测流是否存在
fun1() {
    a=$(curl -s $1)
    if [ -z "$a" ]; then
	sleep 5
	echo "${alias} $(date) can't touch" >>  ./error.log
        return 1
    else 
        return 0
    fi
}
#检测文件是否变化
fun2() {
    old=$(curl -s $1 | md5sum)
    sleep 5
    new=$(curl -s $1 | md5sum)
    if [ "${old}" != "${new}" ]; then
	:
    else
	echo "$2 $(date)" >> ./file.log
    fi
}
#上面的测试记录
#fun1 "http://58.220.102.229:1970/otv/nyz/live/channel31/700.m3u8"
#if [ "$?" == "0" ]; then
#    echo "ok"
#    fun2 "http://58.220.102.229:1970/otv/nyz/live/channel31/700.m3u8"
#else
#    echo "bad"
#fi
# 根据日期进行日志备份
time=$(date +%d)
if [ $time == "1" ]; then
    mv file1.log file2.log
    mv file.log file1.log
fi 
#IFS=$'\n'
#读取配置文件运行
while true; do
    for line in $(cat m3u8.conf); do
#	echo $line
	if [[ $line =~ ^\#.*\#$ ]] || [[ $line =~ ^$ ]]; then
	    continue
	else
	    var=(${line//#/ })
	    if [ ${#var[@]} -ne 2 ]; then
		echo "the num of parameter is wrong"
		echo "the right number is 2"
		exit
	    else
		url=${var[0]}
		alias=${var[1]}
	    fi
#	    echo "url=${url} alias=${alias}"
	    fun1 ${url}
	    if [ "$?" == "0" ]; then
#		echo "ok"
		fun2 ${url} ${alias}
	    else
		echo "bad"

	    fi
	fi
    done
done
    





