container_name=$1

xhost +local:
docker run -it --net=host --gpus all  -e DISPLAY=${DISPLAY} \
  -e QT_GRAPHICSSYSTEM=native \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e XAUTHORITY \
  -u `id -u`:`id -g` --workdir="/home/$USER/" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"  -v "/etc/passwd:/etc/passwd:rw"  -e "TERM=xterm-256color" \
  --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools  \
  --device /dev/nvidia1 \
  -v "/media/sda1:/home/$USER/media/sda1" \
  -v "/media/sdc1:/home/$USER/media/sdc1" \
  -v "/home/$USER/code/docker_home/cvo/:/home/$USER/" \
  --name=${container_name}  \
  umrobotics/cvo:latest
  #--user=$(id -u) \
#  -v "/home/$USER/code/docker_home:/home/$USER/" \    # map the "/home/$USER/code/docker_home" outside docker as the docker container's home dir
#  -v "/run/media/$USER/Samsung_T5/:/home/$USER/media/Samsung_T5" \   # map the external SSD/HDD into docker container
#  --device=/dev/dri:/dev/dri \
#  --name=${container_name} \
#  umrobotics/cuda_arch:latest
#>>>>>>> origin/master
