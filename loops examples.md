for i in {4..8}; do ping -c 1 -t 1 8.8.$i.$i > /dev/null && echo host 8.8.$i.$i is up; done
while true; do true; done &
