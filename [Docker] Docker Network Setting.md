# Docker Network Setting

* create docker network
```
docker network create --subnet=192.168.15.0/24 lim-net
```

*  Network Settings and running docker
```
docker run ${other args..} --net lim-net --ip 192.168.15.3 ${image name}
```
