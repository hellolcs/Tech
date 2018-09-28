# 환경 구성
- 사전에 Java가 설치 되어 있어야 함
- NameNode, DataNode, Qdevice 모두 해주어야 함

### user/usergroup 생성 (필요 없으면 안해도 됨)
- Case1 : 별도 스토리지를 마운트 하지 않을 경우
  * 모든 서버에 hadoop 유저그룹과 hduser 유저 생성
````
$ sudo groupadd hadoop
$ sudo useradd -g hadoop -d /data hduser
$ passwd hduser   #passwd : castis or 사이트 규칙에 맞춰서..
````
  * Case2 : 별도 스토리지를 마운트 할 경우
````
$ sudo groupadd hadoop
$ sudo useradd -g hadoop hduser
$ passwd hduser   #passwd : castis or 사이트 규칙에 맞춰서..

# 스토리지 마운트! (/data에 마운트 했다고 가정)

$ usermod -d /data hduser
$ cp /home/hduser/.bash* /data/
````


- sudouers file에 hduser 추가
```
$ sudo visudo
----------------------------------------------------------------------------------
hduser ALL=(ALL:ALL) ALL
```
- hduser로 로그인
```
$ su - hduser
```

### ssh 설정 (공개키 생성 / NameNode만 진행)
- ssh 설정 변경
```
$ sudo vi /etc/ssh/sshd_config
----------------------------------------------------------------------------------
PubkeyAuthentication yes
AuthorizedKeysFile      .ssh/authorized_keys
```

- 공개키를 생성
```
$ mkdir ~/.ssh
$ chmod 700 ~/.ssh
$ ssh-keygen -t rsa -P ""
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
$ sudo systemctl restart sshd
```

- 공개키를 DataNode 각 서버에 배포 
```
$ ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.160.xx
$ ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.160.xx
$ ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.160.xx
```

- 접속 테스트
```
$ ssh 192.168.160.xx
```

### hosts 파일 수정
- hosts 파일 수정 (각 서버들의 HostName을 등록)
  * Loopback은 주석처리
```
$ sudo vi /etc/hosts
----------------------------------------------------------------------------------
10.1.1.58       NameNode-01
10.1.1.59       NameNode-02
10.1.1.60   Hdfs-Qdevice
10.1.1.13       DataNode-01
10.1.1.15       DataNode-02
10.1.1.221      DataNode-03
```
- 확인
```
$ cat /etc/hosts
```

# HDFS 설치 
### 하둡 설치([파일 다운로드](http://hadoop.apache.org/releases.html#22+March%2C+2017%3A+Release+2.8.0+available))
- 압축 해제
```
$ tar -zxf /data/hadoop-2.8.0.tar.gz
$ ln -sf hadoop-2.8.0 hadoop
```

- 유저계정에 path설정 (JAVA_HOME 경로와 HADOOP_HOME 경로는 설치 경로로 할 것)
  * 해당 설명은 java의 경우 tar 파일로 받아 /usr/local/java 경로에 위치함
```
$ vi ~/.bashrc
----------------------------------------------------------------------------------
# Java and Hadoop variables
export JAVA_HOME=/usr/local/java
export HADOOP_HOME=/data/hadoop
export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
export HADOOP_PREFIX=$HADOOP_HOME
export HADOOP_COMMON_HOME=${HADOOP_PREFIX}
export HADOOP_PID_DIR=${HADOOP_HOME}/pids
export HADOOP_HDFS_HOME=${HADOOP_PREFIX}
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}
                                                              
```

- 시스템 path설정 (Java 경로와 Hadoop 경로는 설치 경로로 할 것)
```
$ sudo vi /etc/profile
----------------------------------------------------------------------------------
# Java and Hadoop variables
export JAVA_HOME=/usr/local/java
export HADOOP_HOME=/data/hadoop
export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
export HADOOP_PREFIX=$HADOOP_HOME
export HADOOP_COMMON_HOME=${HADOOP_PREFIX}
export HADOOP_PID_DIR=${HADOOP_HOME}/pids
export HADOOP_HDFS_HOME=${HADOOP_PREFIX}
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}
                                                                     
```
```
$ source /etc/profile
```
- hadoop 환경 설정
```
$ vi /data/hadoop/etc/hadoop/hadoop-env.sh
----------------------------------------------------------------------------------
export JAVA_HOME=/usr/local/java (수정)
export HADOOP_PID_DIR=/data/hadoop/pids (수정)

export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native
export HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=$HADOOP_PREFIX/lib/native"
```

### Hadoop 설정 변경
- slave node 등록 (DataNode가 동작하는 모든 컴퓨터를 등록 / include_server 사용시 필요 없음???)
```
$ vi /data/hadoop/etc/hadoop/slaves
----------------------------------------------------------------------------------
DataNode-01
DataNode-02
DataNode-03
(이하 생략...)
```
- journal node 등록 (Journal Node가 동작하는 모든 컴퓨터를 등록)
```
$ vi /data/hadoop/etc/hadoop/journalnodes
----------------------------------------------------------------------------------
NameNode-01
NameNode-02
Hdfs-Qdevice
```
- config  변경
```
$ vi /data/hadoop/etc/hadoop/core-site.xml
----------------------------------------------------------------------------------
<configuration>
    <property>
        <name>fs.defaultFS</name> 
        <value>hdfs://hadoop-cluster</value> 
    </property> 
    <property> 
        <name>ha.zookeeper.quorum</name> 
        <value>NameNode-01:2181,NameNode-02:2181,Hdfs-Qdevice:2181</value> 
    </property> 
</configuration>
```
```
$ vi /data/hadoop/etc/hadoop/hdfs-site.xml
----------------------------------------------------------------------------------
<configuration> 
    <property> 
        <name>dfs.replication</name> 
        <value>3</value> 
    </property> 
    <property> 
        <name>dfs.namenode.name.dir</name> 
        <value>/data/hadoop/repository/dfs/namenode</value> 
        <final>true</final> 
    </property> 
    <property> 
        <name>dfs.datanode.data.dir</name> 
        <value>/data/hadoop/repository/dfs/datanode</value> 
        <final>true</final> 
    </property> 
    <property> 
        <name>dfs.journalnode.edits.dir</name> 
        <value>/data/hadoop/repository/dfs/journalnode</value> 
    </property> 

    <!-- HA configuration --> 
    <property> 
        <name>dfs.nameservices</name> 
        <value>hadoop-cluster</value> 
    </property> 
    <property> 
        <name>dfs.ha.namenodes.hadoop-cluster</name>
        <value>nn1,nn2</value>
    </property> 
    <property>
        <name>dfs.namenode.rpc-address.hadoop-cluster.nn1</name>
        <value>NameNode-01:8020</value>
    </property> 
    <property> 
        <name>dfs.namenode.rpc-address.hadoop-cluster.nn2</name> 
        <value>NameNode-02:8020</value>
    </property> 
    <property> 
        <name>dfs.namenode.http-address.hadoop-cluster.nn1</name>
        <value>NameNode-01:50070</value>
    </property>
    <property> 
        <name>dfs.namenode.http-address.hadoop-cluster.nn2</name>
        <value>NameNode-02:50070</value> 
    </property> 


    <!-- Storage for edits' files --> 
    <property> 
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://NameNode-01:8485;NameNode-02:8485;Hdfs-Qdevice:8485/hadoop-cluster</value>
        </property>
    <property>
        <name>dfs.namenode.max.extra.edits.segments.retained</name>
        <value>1000000</value>
    </property> 

    <!-- Client failover -->
    <property> 
        <name>dfs.client.failover.proxy.provider.hadoop-cluster</name> 
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value> 
    </property>

    <!-- Fencing configuration -->
    <property> 
        <name>dfs.ha.fencing.methods</name>
        <value>shell(/data/zookeeper/bin/zkServer.sh --nameservice=hadoop-cluster NameNode-01:8485)</value>

    </property> 
    <!-- Automatic failover configuration -->
    <property>
        <name>dfs.ha.automatic-failover.enabled</name>
        <value>true</value>
    </property>
</configuration>
```
- 필요 파일 생성
```
$ touch /data/hadoop/etc/hadoop/include_server
$ touch /data/hadoop/etc/hadoop/exclude_server
```

### 전 노드에 배포
- hadoop 폴더 압축 및 배포
```
$ tar -cvjpf hadoop-castis.tar.bz2 hadoop-2.7.1
$ scp hadoop-castis.tar.bz2 10.1.1.xx
```
- Node 마다 hadoop Link 생성 (tar 파일 받은 노드)
```
ln -sf hadoop-2.7.1 hadoop
```

# Zookeeper 설치 및 실행! 
- [ZooKeeper 설치 보러가기](https://github.com/hellolcs84/Tech/wiki/%5BZookeeper%5D-%EC%84%A4%EC%B9%98)

# hadoop 실행
- 실행전 라이브러리 확인
  * hadoop : false 일 경우 hadoop을 Complie 후 Library 복사 필요 
  * 전노드에 복사 ([Hadoop Complie 보러 가기](https://github.com/hellolcs84/Tech/wiki/%5BHADOOP%5D%5BHDFS%5D-Complie))
```
$ hadoop/bin/hadoop checknative -a
----------------------------------------------------
Native library checking:
hadoop:  true /data-cdp/hadoop-2.8.0/lib/native/libhadoop.so.1.0.0
zlib:    true /lib64/libz.so.1
snappy:  false 
lz4:     true revision:10301
bzip2:   true /lib64/libbz2.so.1
openssl: true /usr/lib64/libcrypto.so
17/07/04 18:05:24 INFO util.ExitUtil: Exiting with status 1
```

- JournalNode 실행 (모든 journalnode에서 실행)
  * 반드시 네임노드 전에 실행 해야 함
```
/data/hadoop/sbin/hadoop-daemon.sh start journalnode
```

- ZKFC(ZooKeeperFailoverController) 초기화 (Active 만 진행)
```
$ /data/hadoop/bin/hdfs zkfc -formatZK
```

- NameNode 포맷 (Active만 진행)
```
$ /data/hadoop/bin/hdfs namenode -format
```

- Active NameNode 실행
```
$ /data/hadoop/sbin/hadoop-daemon.sh start namenode
```

- Standby NameNode 실행
```
$ /data/hadoop/bin/hdfs namenode -bootstrapStandby
$ /data/hadoop/sbin/hadoop-daemon.sh start namenode
```
- ZooKeeper Failover Controller 실행 (namenode 모두)
```
$ /data/hadoop/sbin/hadoop-daemon.sh start zkfc
```
- DataNode 실행 (전체 DataNode)
```
$ /data/hadoop/sbin/hadoop-daemon.sh start datanode
```