container_name=$1

xhost +local:
docker run -it --net=host --gpus all  -e DISPLAY=${DISPLAY} \
  -e QT_GRAPHICSSYSTEM=native \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e XAUTHORITY \
  -u `id -u`:`id -g` --workdir="/home/$USER/" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"  -v "/etc/passwd:/etc/passwd:rw"  -e "TERM=xterm-256color" \
  --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools  \
  -v "/home/$USER/code/docker_visualization_home/:/home/$USER/" \
  -v "/run/media/$USER/Samsung_T5/:/home/$USER/media/Samsung_T5" \
  -v "/run/media/$USER/Samsung_T5_2/:/home/$USER/media/Samsung_T5_2" --name=${container_name}  umrobotics/semantic_mapping_melodic:latest


#=======
#docker run -it --net=host --gpus all \
#  --user=$(id -u) \
#  -e DISPLAY=$DISPLAY \
#  -e QT_GRAPHICSSYSTEM=native \
#  -e CONTAINER_NAME=cuda \
#  -e NVIDIA_DRIVER_CAPABILITIES=all \
#  -e XAUTHORITY \
#  -e USER=$USER \
#  --workdir=/home/$USER \
#  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#   -v "/etc/passwd:/etc/passwd:ro" \
#   -v "/home/$USER/code/docker_home/visualization/:/home/$USER/" \
#   -v "/media/sda1/:/home/$USER/sda1" \
#   --device=/dev/dri:/dev/dri \
#  --name=${container_name} \
#  umrobotics/semantic_mapping_melodic:latest
#>>>>>>> ec01109 (update old semanticmapping dockerfile)
