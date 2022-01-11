## SLAM
This docker file sets up the environment for running cassie_ros.


### How to build the docker image from `Dockerfile`?
If you want to make any changes to this docker image, edit the `Dockerfile`. If any changes happends, remember to update the `LABEL version` inside. 
Then to build the docker image so that you can run it, type `docker build --tag umrobotics/slam .`


### How to run this docker file?
`docker-compose run slam`
