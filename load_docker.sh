HOSTS_AVAILABLE=$(bhosts | awk '$2 == "ok" {print $1}')
for host in $HOSTS_AVAILABLE; do
    echo "Available host: $host"
done

# delete the docker image
IMAGE_NAME="10.120.24.15:5000/jhinno/ric3:latest"

for host in $HOSTS_AVAILABLE; do
  if [[ "$host" != *cpu* ]]; then
    continue
  fi
  # check if the image exists
  if ! bsub -Ip -n 1 -m $host docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^$IMAGE_NAME$"; then
    echo "Image $IMAGE_NAME does not exist in host:$host. Exiting."
    continue
  fi

  # find all containers using the image
  CONTAINERS=$(docker ps -a -q --filter "ancestor=$IMAGE_NAME")

  # stop and remove containers using the image
  if [ -n "$CONTAINERS" ]; then
    echo "Stopping and removing containers using the image: $IMAGE_NAME on host: $host"
    bsub -Ip -n 1 -m $host docker stop $CONTAINERS
    bsub -Ip -n 1 -m $host docker rm $CONTAINERS
  else
    echo "No containers found using the image: $IMAGE_NAME on host: $host"
  fi

  # removing
  echo "Removing image: $IMAGE_NAME on host: $host"
  bsub -Ip -n 1 -m $host docker rmi -f $IMAGE_NAME
  echo "Done."

done



docker load < ric3.tar
echo "finished docker load"

docker tag ric3:latest 10.120.24.15:5000/jhinno/ric3:latest
echo "finished docker tag"

docker push 10.120.24.15:5000/jhinno/ric3:latest
echo "finshed docker push"
#
for host in $HOSTS_AVAILABLE; do
    echo "pull the docker on available host: $host"
    if [[ "$host" != *cpu* ]]; then
        continue
    fi
    bsub -Ip -n 1 -m $host docker pull 10.120.24.15:5000/jhinno/ric3:latest
done

echo "$HOSTS_AVAILABLE" > $HOME/hosts_available.cfg
