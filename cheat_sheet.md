for i in {4..8}; do ping -c 1 -t 1 8.8.$i.$i > /dev/null && echo host 8.8.$i.$i is up; done
    for i in {1..300}; do sudo docker pull nginx:alpine && sudo docker image rm nginx:alpine; done
while true; do true; done &
history | awk -F "  " '{print $3 $4 $5 $6 $7 $8 $9}' | sort | uniq -c | sort

sudo cat /proc/net/nf_conntrack | awk '{if ($7 ~ /src/ ) print $7; else if ($6 ~ /src/) print $6}' | sed "s/src=/ /g" | sort | uniq -c > result2.txt

ps -ef | grep -q 'bin/[s]shd' && echo 'ssh is running' || echo 'ssh not running' 


ps aux | grep hidd  | grep -v grep | awk  '{print $2}'

Load Analysis:
sudo lsof  -p 7317 | wc
ps -eLf | grep /usr/bin/docker | wc

grep --after-context=10 outputs terraform.tfstate
