# Docker Command

* Docker Image 찾기
```
docker search [image_name]
docker search centos
```

* Docker Image download
```
docker image pull [image_name]:[tag]
docker iamge pull centos:6.7
```

* Docker start (run)
```
docker run -h centos-6-lim --name centos-6-lim --net lim-net --ip 192.168.15.3 -v /root/lim/share:/share --rm -it centos:6.7 /bin/bash  
# -h : hostname
# --name : docker container name
# --net : docker network / must be created network before run
# -v : mount host storage
# --rm : kill container after exit shell
# -it : enable input terminal
```

* Docker start#2 (User Application run)
```
docker run --name lim-test --net lim-net --ip 192.168.15.3 --rm -d lim-vod2:6.7
# -d : detach mode
```

* Remove multiple terminated processes
```
docker rm -v $(docker ps -a -q -f status=exited)
# rm -v : remove connected data volume
# -a : all container
# -f : filter
# -q : print only container ID
```