# SLAM

This docker file sets up the environment for [CURLY SLAM](https://github.com/UMich-CURLY/curly_slam).

## Usage
1. Install `docker` and `docker-compose`. See [Wiki](https://github.com/UMich-CURLY/docker_images/wiki) for more details about Docker.
1. Make sure you have Nvidia driver installed.
    - If you are not using Nvidia GPU, change the first line of the `Dockerfile` to: 
        ```
        FROM ubuntu:20.04
        ```
    - If you want to use `CUDA`, please follow [this guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#linux-distributions) to install `nvidia-container-toolkit`. Maybe skip this step for now if you don't know what `CUDA` is.
    -  Docker on MacOS or Windows is not suggested because lack of GPU support. You may encounter opengl issues when using `rviz`.
1. Clone this repository:
    ```bash
    git clone git@github.com:UMich-CURLY/curly_slam.git
    ```
1. Build the Docker image:
    ```bash
    cd docker
    docker build --build-arg USER=$USER --tag umcurly/curly_slam .
    ```
    - See `build.log` for building details. The image may take ~20 minutes to build, so please grab a cup of coffee and relax.
    - If you encounter any problem during this step, please submit a new issue and paste your error message there. We will help you as soon as possible.
1. When you finish the coffee or the container is built, please check `docker-compose.yml`.
    - You may want to change line 44-45 (or somewhere around):
        ```bash
        - /home/$USER/Projects/curly_slam/:/home/${USER}/ws/
        - /run/media/$USER/CTOS-Storage/data/:/home/${USER}/ws/external_data/
        ```
        These two lines will make the folders on your host system available inside the container.
    - It is a good practice to keep your working files on your host system. In that way, if the container is deleted by accident (which happens a lot), you will not lose your works. Guess how I learn this~
    - If you are not using Nvidia GPU or you are using docker on MacOS or Windows, delete or comment out these lines in `docker-compose.yml`: 
        ```yaml
        - "NVIDIA_DRIVER_CAPABILITIES=all"
        ...
        deploy:
          resources:
            reservations:
              devices:
                - driver: nvidia
                  count: 1
                  capabilities: [gpu]
        ```
    - For more configuration please see [compose-file](https://docs.docker.com/compose/compose-file/compose-file-v3/).
1. Run this command to open a new container with your `docker-compose.yml` config:
    ```bash
    docker-compose run slam
    ```
    Note: You don't need to run `docker-compose run slam` every time you want to enter your existing workspace. You can use `docker start [container_id]` and `docker exec -it [container_id] /bin/bash`  to enter your old container.  

1. Voilà！ Now try to build your ROS workspace!



## FAQ

### Can I use docker on my Mac or Windows PC?

It depends. Using docker directly on your Mac will cause rviz to crash due to lack of GPU support. However, you may try to run docker in a virtual machine, where GPU functions are simulated. Using this image in a virtual machine will save your time in installing ROS environment. For GUI, please see this [guide (MacOS)](http://mamykin.com/posts/running-x-apps-on-mac-with-docker/) or [guide (Windows)](https://cuneyt.aliustaoglu.biz/en/running-gui-applications-in-docker-on-windows-linux-mac-hosts/).

### Can I use GUI in the container?

Yes, you can. Just run `xhost +` on your host system first, and then you can use any GUI programs as you want in the container. The GUI window will show up on your host system.

Note: `xhost +` is simple but unsecure. Check other solutions [here](http://wiki.ros.org/docker/Tutorials/GUI).

### `g++: internal compiler error: Killed (program cc1plus)` (AKA. out of memory)

To take full advantage of all CPU cores, this image will try to use 16 jobs to compile the libraries. However, this may cause an out-of-memory problem, especially when compiling OpenCV. In that case, you can change all `-j6` to `-j4` or even `-j1` to save memory. Another option is to add swap partition. See more discussion here: [make -j 8 g++: internal compiler error: Killed (program cc1plus)](https://stackoverflow.com/questions/30887143/make-j-8-g-internal-compiler-error-killed-program-cc1plus)

### My system freeze when building the libraries!
This is also caused by out of memory problem. Please refer to the last question for solution.

### How to open the container I used last time?

A traditional way is:
```bash
docker container ls -all
# check which container is the one you want
# to use and copy the CONTAINER ID, then run:
docker container start [CONTAINER ID]
docker container attach [CONTAINER ID]
```

A more modern way is:
1. Install VS Code.
1. Install the Docker extension.
1. See everything and control everything in the Docker tab.

### Memory leak when running `roscore`?
Use ulimits config of docker to limit the number of file descriptor. This is fixed by adding `ulimits` to `docker-compose.yml`. Detail information can be found here:
https://answers.ros.org/question/336963/rosout-high-memory-usage/.
