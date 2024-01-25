docker build --build-arg USER=`whoami` --build-arg USER_ID=$(id -u)  --build-arg GROUP_ID=$(id -g)   --tag umrobotics/cvo:latest .
