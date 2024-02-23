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
- `-v <volume_name>:<mountpoint in the container>`

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

### docker exec
to execute a command in a container
`docker exec -ti <container_name> <command>` with -ti to get a terminal
Example: docker exec -ti myContainer bash

## the volumes

By default the data of a container isn't persistent: it disappear when the container is destroyed. That's wy there are Containers Volumes.
Pros:
- allows data persistance
- can be shared between containers (with multi-access and permission management)
- can be local or remote
- useful for backup

### docker volume commands
#### docker volume ls
to see all the existing volumes
#### docker volume create
to create a volume:
`docker volume create <VolumeName>`
To run a docker using it: 
`docker run -v <volume_name>:<mountpoint in the container> <container_name>:<tag>'
	Example:
	docker volume create mynginx
	docker run -v mynginx:/usr/share/nginx/html/html nginx:latest
A container can be mounted on a volume already used vy another container (mod multicontainer)
#### docker volume inspect
to inspect the metadata of a volume
`docker volume inspect <volume_name>`
This display the mounting point of the docker. Its content ca be read/write in sudo mode
#### docker volume rm
to remove a docker volume. Requires that this volume isn't currently used by any container (need to be stopped)
`docker rm <volume_name>`

### types de volumes
Remind: docker mounts are based on basic mounts:
	to mount: `sudo mount --bind <source> <dest_to_mount_on_source>`
	to see the architecture with all mounts: `findmnt`
	to unmount: `sudo umount <dest_to_mount_on_source>`
#### bind mount
Do a manual mount, the data in the repo used as a source in the mount are overwriting the volume data of the image. 
#### volumes docker
when the container is run with -v. The data is stored in /var/lib/docker/<volume_name> and is persistent in this repo. The volume data of the image are imported in the volume
#### TMPFS
Temporary memory space to work, lost when the container is stopped. (As for the bind mount the image data are overwritten)
#### How to use them ?
`-v`or`--volume`	<volume name>:<dst_path> -> use a volume
					<path_src>:<path_dst> -> bind
`--mount type=<type>, ...`	with type = bind/mount/tmpfs
- mount: `--mount type=mount,source=<path>,destination=<path>[,readonly/readwrite]`
- volume: `--mount type=volume,source=<volume_name>,destination=<path>`
- tmpfs: `--mount type=tmpfs,destination=<path>`

### UserId and volumes
In the container the users are identified by their userId. In order to run an image using a specific user you must use `docker run`  with the option `-u <user_id or user_name>`.
To add users in a docker you have to add them with the command line `useradd -u <userID> <user_name>` . If you want to have specific users at the creation of the image this command has to be added to the Dockerfile, prefixed by `RUN`
(The `docker exec ...` can also be used with a specific user (by default 0=root) with the same option).


## image creation