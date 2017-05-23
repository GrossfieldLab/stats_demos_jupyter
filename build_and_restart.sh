#!/bin/bash -x
#
# Note: Must be run via sudo

IMAGE=t32/jupyter

# First, stop all running docker containers
docker stop $(sudo docker ps -a -q)

# Now get rid of them...
docker rm $(sudo docker ps -a -q)

# Rebuild the image for jupyter
docker build  --rm --force-rm -t $IMAGE:latest .

# Get a token and record it...
export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
echo $TOKEN >token.current


# Now restart everything...
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN  --name=proxy jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN  -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py --image=$IMAGE --container-user=jovyan --command='jupyter notebook --no-browser --port {port} --ip=0.0.0.0 --NotebookApp.base_url=/{base_path} --NotebookApp.port_retries=0 --NotebookApp.token="" --NotebookApp.disable_check_xsrf=True'
