### nginx配置文件更改参数的脚本
-----------------------------------------------
* 把需要更改的行数保存到数据结构字典当中<br>
```Bash 
declare -A dic
dic=([25]="advert_pos 0; #广告插入的位置, 0为后, 1为前;"  \
     [26]="advert_path /usr/local/guanggao/mov; #广告路径，放入广告m3u8及相关的ts文件"  \
     [27]="advert_num  2; #广告个数，广告命名为数据，如0.ts,1.ts...."  \
     [28]="live_advert_time "  \
     [31]="location ~ \.ts$ {"  \
     [32]="advert_ts;"  \
     [33]="}" )
```
* 创建参数修改函数避免重复代码
```Bash
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
```


