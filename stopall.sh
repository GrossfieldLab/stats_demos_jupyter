#!/bin/bash -x
#
# Note: Must be run via sudo

# First, stop all running docker containers
docker stop $(sudo docker ps -a -q)

# Now get rid of them...
docker rm $(sudo docker ps -a -q)

