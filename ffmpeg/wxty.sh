#!/bin/bash
#this script is for daily job
prefix=/var/www/lighttpd
conffile=./wxty.conf
mypwd=/var/www/lighttpd/temp/
url1=http://172.26.162.3/otv/wxty/review/channel01/700.m3u8
url2=http://renjidazhan.otvcloud.com/otv/renji/review/channel01/1300.m3u8
url3=http://58.220.102.228:1970/otv/nyz/review/channel31/index.m3u8
url4=http://172.26.162.3/otv/wxty/review/channel11/1300.m3u8


# 检查配置文件是否存在
if [ ! -f "$conffile" ]; then
    echo "There is no this file"
    exit
fi
#删除前一天生成的文件(在做脚本测试时，要在前面加入备注否则多次会删除文件)
for file in $(< file.log2); do
    if [ ! -f "$file" ]; then
       continue;
    else
      rm -f $file
    fi
done
mv file.log1 file.log2
mv $prefix/mission1.html $prefix/mission2.html
mv $prefix/mission1 $prefix/mission2
mv file.log  file.log1
mv $prefix/mission.html $prefix/mission1.html
mv $prefix/mission  $prefix/mission1


#清空昨天的任务和文件记录
> $prefix/mission
> file.log
> $prefix/mission.html
#解析配置文件
for line in $(< wxty.conf); do
    if [[ $line =~ ^\#.*\#$ ]] || [[ $line =~ ^$ ]]; then
        continue;
    else
        var=(${line//:/ })
        if [ ${#var[@]} -ne 4 ]; then
           echo "the num of parameter is wrong"
           echo "the right number is 4"
           exit
        else
            if [ ${#var[0][@]} -ne 11 ]; then
               echo "the bit of value is wrong"
               echo "time has 11 bit"
               exit
            else
                time=${var[0]}
                length=${var[1]}
                filename=${var[2]}

            fi
        fi
 #执行命令
        if [[ ${var[3]} == 1 ]];then
          url=${url1}
        elif [[ ${var[3]} == 2 ]]; then
          url=${url2}
        elif [[ ${var[3]} == 3 ]]; then
          url=${url3}
        else
          url=${url4}
        fi
        echo "${var[3]}"

        echo "time=$time length=$length filename=$filename"
        ffmpeg -i "${url}?starttime=2017${time}&length=${length}" -c copy ${mypwd}${filename}.ts
         #记录生成文件状态
        if [ ! -f "$prefix/temp/$filename.ts" ]; then
                echo "$(date):$filename" >> ./error.log
        else
                echo "http://222.68.17.119/temp/$filename.ts" >> $prefix/mission
                echo "$prefix/temp/$filename.ts" >> ./file.log

        fi
    fi
done
#生成HTLM文件
echo "<!DOCTYPE html>" >> $prefix/mission.html
#echo "<html lang=\"zh-cn\">" >> $prefix/mission.html
echo "<head>" >> $prefix/mission.html
echo "<meta charset=\"utf-8\" />" >> $prefix/mission.html
echo "</head>" >> $prefix/mission.html
echo "<body>" >> $prefix/mission.html
for  line in $(< $prefix/mission); do
  echo "<a href="$line"> $line </a> <br />" >> $prefix/mission.html
done




