

## 컴파일 사전 작업
- Hadoop Source Download ([파일 다운로드](http://mirror.apache-kr.org//hadoop/common/))

- 압축 해제
```
$ tar -xvf hadoop-2.8.0-src.tar.gz
```

- protobuf 버전 확인 및 다운로드
  * 아래 부분의 protobuf 버전이 필요 ([파일 다운로드](https://github.com/google/protobuf/releases?after=v2.6.1))
```
vi hadoop-2.8.0-src/hadoop-project/pom.xml
-----------------------------------------------------------
<protobuf.version>2.5.0</protobuf.version>
```

- protobuf 설치
```
$ tar -zxvf protobuf-2.5.0.tar.gz 
$ cd protobuf-2.5.0 
$ ./configure --prefix=/usr/local/lib/protobuf-2.5.0 
$ make && make install 
$ export PATH=/usr/local/lib/protobuf-2.5.0/bin/:$PATH
$ protoc --version
-----------------------------------------------------------
libprotoc 2.5.0
```

- Maven 버전 확인 및 다운로드 ([파일 다운로드](http://apache.mirror.cdnetworks.com/maven/maven-3/))
  * 상위 버전 필요
```
vi hadoop-2.8.0-src/hadoop-project/pom.xml
-----------------------------------------------------------
<enforced.maven.version>[3.0.2,)</enforced.maven.version>
```

- Maven 설치
```
$ tar -xvf apache-maven-3.0.5-bin.tar.gz
$ mv apache-maven-3.0.5 /usr/local/
$ cd /usr/local/
$ ln -sf apache-maven-3.0.5/ maven
$ export MAVEN_HOME="/usr/local/maven"
$ export PATH=$MAVEN_HOME/bin:$PATH
$ mvn -version
-----------------------------------------------------------
Apache Maven 3.0.5 (r01de14724cdef164cd33c7c8c2fe155faf9602da; 2013-02-19 22:51:28+0900)
Maven home: /usr/local/maven
Java version: 1.8.0_131, vendor: Oracle Corporation
Java home: /usr/local/jdk1.8.0_131/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "2.6.32-358.el6.x86_64", arch: "amd64", family: "unix"
```

- hadooop complie
  * 인터넷 연결 필요 (Maven에서 필요한 download 받음)
```
$ cd hadoop-2.5.2-src 
$ mvn package -Pdist,native -DskipTests -Dtar 
```

  * 아래 애러 발생 시 cmake or openssl-devel or gcc-c++ 중 없는 rpm 설치 ([파일 다운로드](http://mirror.cdnetworks.com/centos/))
    * OS 버전 > OS > x86_64 > Packages > cmake-x.x.x....rpm
    ````
    [ERROR] Failed to execute goal org.apache.maven.plugins:maven-antrun-plugin:1.7:run (make) on project hadoop-pipes: An Ant BuildException has occured: exec returned: 1
    ````

   
    * 작성자가 설치시에는 openssl-devel이 없어서 yum 설치함 (의존성 있는 rpm도 설치됨 / 아래 참고)
    ````
    Installing:
    openssl-devel                                                    x86_64                                              1.0.1e-57.el6                                                  base                                              1.2 M
    Installing for dependencies:
    keyutils-libs-devel                                              x86_64                                              1.4-5.el6                                                      base                                               29 k
    krb5-devel                                                       x86_64                                              1.10.3-65.el6                                                  base                                              504 k
    libcom_err-devel                                                 x86_64                                              1.41.12-23.el6                                                 base                                               33 k
    libkadm5                                                         x86_64                                              1.10.3-65.el6                                                  base                                              143 k
    Updating for dependencies:
    e2fsprogs                                                        x86_64                                              1.41.12-23.el6                                                 base                                              554 k
    e2fsprogs-libs                                                   x86_64                                              1.41.12-23.el6                                                 base                                              121 k
    keyutils                                                         x86_64                                              1.4-5.el6                                                      base                                               39 k
    keyutils-libs                                                    x86_64                                              1.4-5.el6                                                      base                                               20 k
    krb5-libs                                                        x86_64                                              1.10.3-65.el6                                                  base                                              675 k
    libcom_err                                                       x86_64                                              1.41.12-23.el6                                                 base                                               38 k
    libss                                                            x86_64                                              1.41.12-23.el6                                                 base                                               42 k
    ````

- library 복사
  * 컴파일 후 생성되는 native library를 hadoop에 복사
  * $HADOOP_HOME/lib/navive에 있는 library는 백업
```
$ mv $HADOOP_HOME/lib/native $HADOOP_HOME/lib/native_backup
$ cp -aR hadoop-2.5.2-src/hadoop-dist/target/hadoop-2.7.1/lib/native $HADOOP_HOME/lib/native
```
