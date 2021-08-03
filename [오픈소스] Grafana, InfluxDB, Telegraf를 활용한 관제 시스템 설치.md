Download : https://www.influxdata.com/downloads/

## InfluxDB

### Installation
```
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.2.0.x86_64.rpm
sudo yum localinstall influxdb-1.2.0.x86_64.rpm

wget https://dl.influxdata.com/influxdb/releases/influxdb-1.2.0_linux_amd64.tar.gz
tar xvfz influxdb-1.2.0_linux_amd64.tar.gz
```

### Connect & Create Database
```
service influxdb start
influx
create database ${DB_NAME}
```


## Telegraf

### Installation

```
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.2.1.x86_64.rpm
sudo yum localinstall telegraf-1.2.1.x86_64.rpm

wget https://dl.influxdata.com/telegraf/releases/telegraf-1.2.1_linux_amd64.tar.gz
tar xvfz telegraf-1.2.1_linux_amd64.tar.gz
```

### Config & Run
```
편의를 위해 /etc/hosts 에monitoring 서버 추가 ex) 172.16.32.105 influxdb
cd /etc/telegraf
telegraf -sample-config -input-filter cpu:disk:kernel:mem:net:netstat:system -output-filter influxdb > telegraf.conf
```
`vim /etc/telegraf/telegraf.conf`
```
hostname = "xxx" # use as key in influxdb 
[[outputs.influxdb]]
urls = ["http://influxdb:8086"]
database = "${DB_NAME}"
precision = "s"
retention_policy = "default"
write_consistency = "any"
timeout = "5s"
```
`service telegraf start`



## Grafana

### Installation
```
yum install https://grafanarel.s3.amazonaws.com/builds/grafana-4.1.1-1484211277.x86_64.rpm

service grafana-server start
```

#### Configuration
`vi /etc/grafana/grafana.ini`
```
;http_port = 3000  # port change
```

## influx command
- connect console : `influx`
- create account : `CREATE USER castis WITH PASSWORD ‘castis’ WITH ALL PREVILEGES;`
- check account : `show user;`
