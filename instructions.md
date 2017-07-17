# Setting up T32 tmpnb server

### Basic installation

* Install docker (if necessary):
  * If you have an existing dnf installed version, remove it with
```
dnf remove docker docker-common docker-selinux docker-engine-selinux docker-engine
```
  * Add the docker repo,
```
dnf config-manager --add-repo \
  https://download.docker.com/linux/fedora/docker-ce.repo
```
  * Update the package index,
```
dnf makecache fast
```
  * And install docker-ce with
```
dnf install docker-ce
```
  * Move `/var/lib/docker` to `/home/docker` and place a symlink from `/var/lib` (or create the dir and add a symlink)
    * Docker images/containers can get big and you can easily fill-up the / partition,
    which is why I move it to `/home`.  This is still on the SSD so should be fast...
* Enable docker daemon at boot via `systemctl`
* Install jupyter using pip
  * Initial installation was broken.  Fix by uninstalling `traitlets` and then reinstalling it with pip
* You _may_ need to install a few docker images first:
```
docker pull jupyter/tmpnb
docker pull jupyter/configurable-http-proxy
```
* Placed `proxy.conf` in `/etc/httpd/conf.d` to enable proxying of tmpnb

### T32 specific

* Clone T32_stats repo
* Using sudo:
```
bash build_base.sh
bash build_and_start.sh
```

## Updating or restarting the tmpnb server

* git update the repo
* Using sudo, run one of the following scripts:
  * `build_and_restart.sh` will stop running docker images, clear everything out, and then rebuild and restart.
  * `build_and_start.sh` will just build and then start (skips the cleaning stage)

## Errata

### Stopping everything
There is a script to stop running containers and remove them called `stopall.sh`.  Sometimes,
the containers can get "stuck" (it seems because of mounts escaping from within the container).  Stop docker with `systemctl stop docker`.  Then look in `/home/docker/containers` and manually remove any if they are still there.  Then restart docker.  This _should_ get rid of everything.  You can confirm with `docker ps -a` to show all containers (including exited ones).

### Dealing with images
Docker images contain the pre-built OS (along with extra software, etc).  You can list these by running `docker images`.  If you need to clean out old images (e.g. you want to rebuild everything from scratch), then stop and remove all containers and remove the images using `docker rmi <id>`.  In general, when using the T32_stats scripts, existing containers should get updated and not leave old ones around.
