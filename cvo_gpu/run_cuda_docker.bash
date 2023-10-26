container_name=$1

xhost +local:

## Note: a) update  -v "/home/$USER/code/docker_home/cvo/:/home/$USER/" for specifying your home directory inside docker
##       b) update "/run/media/$USER/Samsung_T5/:/home/$USER/media/Samsung_T5"  to your own external hard drive if any
docker run -it --net=host --gpus all  -e DISPLAY=${DISPLAY} \
  -e QT_GRAPHICSSYSTEM=native \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e XAUTHORITY \
  -v /etc/group:/etc/group:ro \
  -u $(id -u):$(id -g) --workdir="/home/$USER/" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"  -v "/etc/passwd:/etc/passwd:rw" -v  "/etc/group:/etc/group:ro"  -v "/etc/shadow:/etc/shadow:ro" -e "TERM=xterm-256color" \
  --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools  \
  -v "/home/link/Projects/:/home/$USER/" \
  -v /run/media/link/Samsung_T5/:/dataset \
  --name=cvo_stack  umcurly/cvo:latest

# docker run -it --net=host --gpus all  -e DISPLAY=${DISPLAY} \
#   -e QT_GRAPHICSSYSTEM=native \
#   -e NVIDIA_DRIVER_CAPABILITIES=all \
#   -e XAUTHORITY \
#   -v /etc/group:/etc/group:ro \
#   -u $(id -u):$(id -g) --workdir="/home/$USER/" \
#   -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"  -v "/etc/passwd:/etc/passwd:rw" -v  "/etc/group:/etc/group:ro"  -v "/etc/shadow:/etc/shadow:ro" -e "TERM=xterm-256color" \
#   --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools  \
#   -v /home/$USER/unified_cvo/:/home/$USER/ \
#   -v /media/sdg1/rzh/:/dataset \
#   --name=cvo_stack umrobotics/cvo:latest
