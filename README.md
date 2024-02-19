# 42Inception

## basics commands

In order to avoid typing sudo before every docker command you can add the user to the docker group:
- `sudo usermod -aG docker $USER`

### docker ps
To display the containers
- `docker ps`
Options:
- `-a` to display all the containers including the ones that are not running anymore
- `q` (quiet), to only display the containers id

### docker run
To run a container
- `docker run <url_registry>/<image_name>:<tag>`
In the image tag we usually give the image version (`latest` to get the latest version)
Options :
- `-d` to detach the program (run in the background)
- `--name <container name> `to define the name of the container
- `-ti` to give the container a terminal (if the image allows the use of a terminal)
- `--rm` to automatically remove the container once it is closed (in which you will be root)
- `--hostname <host_name` to give a hostname to the container, by default it is the container id

### docker start
to start a container that has already been generated with the docker run command

### docker stop
to stop the container currently running:
- `docker stop <container_name or container_id`

### docker rm
to remove a container
- `docker rm <container_name or container_id>`
Options:
- `-f` to force the container to stop if it is is currently running, and the remove it 

## the volumes

By default the data of a container isn't persistent: it disappear when the container is destroyed. That's wy there are Containers Volumes.
Pros:
- allows data persistance
- can be shared between containers (with multi-access and permission management)
- can be local or remote 