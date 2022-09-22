container_name=$1

xhost +local:
docker run -it --net=host --gpus all  \
       --user=$(id -u) \
       -u $(id -u):$(id -g) -e XAUTHORITY \
       -v /etc/group:/etc/group:ro \
       -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
       -v "/etc/passwd:/etc/passwd:rw" \
       -v ${HOME}/.Xauthority:/home/$USER/.Xauthority \
       -e "TERM=xterm-256color" \
       --env="QT_X11_NO_MITSHM=1" \
       -e NVIDIA_DRIVER_CAPABILITIES=all -e DISPLAY=$DISPLAY -e USER=$USER \
       -v "/home/$USER/code/docker_home/${container_name}/:/home/$USER/" \
       -v "/run/media/$USER/Samsung_T5/:/home/$USER/code/docker_home/media/Samsung_T5"  --workdir="/home/$USER/" \
       --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools --name=${container_name} \
       umrobotics/visualization:latest



#--env="QT_X11_NO_MITSHM=1"  -e QT_GRAPHICSSYSTEM=native #-e XAUTHORITY \
