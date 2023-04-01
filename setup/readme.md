RACKETutes
===

Installing dependencies, fixing issues and learning new things add too much of overhead to the learning curve. That is why this tutorial series is created. 

This series is configured to run with Jupyter notebook with racket kernal. You can run all your racket experiments within the docker container without installing anything except docker. Credits to [rmculpepper](https://github.com/rmculpepper/iracket) for creating the kernel.

Installing Container
----
First, we need to install docker on your system. For that you can follow the instructions available [here](https://docs.docker.com/engine/install/).

Then we need to clone the docker image with all the configurations from the docker-hub. For that you can use the below command while Docker daemon is running.

```shell
docker pull archfx/rosette
```



[![dockeri.co](https://dockerico.blankenship.io/image/archfx/rosette)](https://hub.docker.com/r/archfx/rosette)

This is configured with the following packages

- Racket
- Rosette
- rtlv
- jupyter


Running the Container
----
Now the container is cloned to our local computer. Before that let's clone the tutorial series from the [GitHub](). Let's use the following command for that after navigating to your favorite location in the terminal.

```shell
git clone https://github.com/Archfx/RACKETutes
```

Then, we need to run the container with the following command and mount the folder which contains our tutorials to the docker container. Here with the `-v` parameter, we mount the tutorial folder.


```shell 
 docker run -t -p 8888:8888 -v "${PWD}/:/RACKETutes" -w /RACKETutes --name rosette archfx/rosette
```
This will log you into the container. If you wish to open the Jupyter notebook on a different terminal window, you can access the container with

```shell
docker exec -it rosette /bin/bash
```
Inside the container, you can initialize the  Jupyter server by the following command.

```shell
jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
```

Click on the link that appears on the container terminal.

If you prefer using VScode to access your racket kernal, you can simply do it by "select another kernal -> remote kernal " and copying the link from the container which looks like

```shell
http://127.0.0.1:8888/?token=91c5042b649115d20684412aeb83588ad8ce3c6ee0f96546
```

Enjoy coding!