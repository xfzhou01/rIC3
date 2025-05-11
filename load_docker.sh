docker load < ric3.tar
echo "finished docker load"

docker tag ric3:latest 10.120.24.15:5000/jhinno/ric3:latest
echo "finished docker tag"

docker push 10.120.24.15:5000/jhinno/ric3:latest
echo "finshed docker push"

# see the available
HOSTS_AVAILABLE=$(bhosts | awk '$2 == "ok" {print $1}')

# the avaliable hosts list
echo "found available hosts:"
for host in $HOSTS_AVAILABLE; do
    echo "Available host: $host"
done

#
for host in $HOSTS_AVAILABLE; do
    echo "pull the docker on available host: $host"
    if [[ "$host" != *cpu* ]]; then
        continue
    fi
    bsub -Ip -n 1 -m $host docker pull 10.120.24.15:5000/jhinno/ric3:latest
done

echo "$HOSTS_AVAILABLE" > $HOME/hosts_available.cfg
