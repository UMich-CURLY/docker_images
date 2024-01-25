## CVO
This docker file sets up the environment for CVO. It aims at installing all non-conflicting related softwares, and encourages download-and-run. Please install [Nvidia-Docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)


### How to build the docker image from `Dockerfile`?

To build the docker image, run `bash build_image.bash`

If you want to make any changes to this docker image, edit the `Dockerfile`. If any changes happends, remember to update the `LABEL version` inside. 

### How to start a new docker container from this docker image?
`bash build_container.bash`. Change the home directly, disk volumn mapping in this bash file correspondingly, in the `docker-compose.yml` file. Note that you only need to do this once. 


### After the docker container is running 
`docker exec -u [your-user-name] -it [container_name] /bin/bash` to use bash as user
`docker exec -u root -it [container_name] /bin/bash` to use bash as root


### when you restart the machine and need to start your old docker container
`docker ps -a` --> Find you old container name 

`docker start [container_name]`  --> start the old container

### Note
If you want use GUI, you can try `xhost local:root` before running `docker exec -it [container_name] /bin/bash`
