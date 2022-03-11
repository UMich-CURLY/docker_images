container_name=$1

xhost +local:
docker run -it --net=host --gpus all \
  --user=$(id -u) \
  --workdir=/home/$USER/ \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "/etc/passwd:/etc/passwd:rw" \
  -v ${HOME}/.Xauthority:/home/$USER/.Xauthority \
  -e "TERM=xterm-256color" \
  --env="QT_X11_NO_MITSHM=1" \
  -e NVIDIA_DRIVER_CAPABILITIES=all -e DISPLAY=$DISPLAY -e USER=$USER \
  -v "/home/$USER/code/docker_visualization_home:/home/$USER/" \
  -v "/run/media/$USER/Samsung_T5/:/home/$USER/code/docker_home/media/Samsung_T5" \
  --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools --name=${container_name} \
  umrobotics/ros-melodic:latest



  #--env="QT_X11_NO_MITSHM=1"  -e QT_GRAPHICSSYSTEM=native #-e XAUTHORITY \
