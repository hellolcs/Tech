# Httpd, Tomcat 설치 및 연동 설정

## JAVA 설치
* JAVA 설치 (추후 버전 관리가 용의하도록 tar 혹은 rpm으로 설치)
```
#rpm -ivh jdk-xxxxx-linux-x64.rpm
```

* JAVA 환경 path 설정
```
(tar 설치시만 진행)
#alternatives --install /usr/bin/java java /usr/local/java/jdk1.x.x_xxx/bin/java 1
#alternatives --install /usr/bin/javac javac /usr/local/java/jdk1.x.x_xxx/bin/javac 1
#alternatives --install /usr/bin/javaws javaws /usr/local/java/jdk1.x.x_xxx/bin/javaws 1

#alternatives --set java /usr/local/java/jdk1.x.x_xxx/bin/java
#alternatives --set javac /usr/local/java/jdk1.x.x_xxx/bin/javac
#alternatives --set javaws /usr/local/java/jdk1.x.x_xxx/bin/javaws

#alternatives --list (확인)
#alternatives --config "((java|javac|javaws))" (버전 변경 시)
```
* JAVA_HOME 설정
```
#vim /etc/profile
///맨아래 추가
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

#echo $JAVA_HOME (확인)
```

## Tomcat 설치
* Download(http://archive.apache.org/dist/tomcat/ 에서 버전 확인)
```
#wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.12/bin/apache-tomcat-9.0.12.tar.gz
#mkdir /app 
#mv apache-tomcat-9.0.12.tar.gz /app
#tar -xvf apache-tomcat-9.0.12.tar.gz
#ln -sf apache-tomcat-9.0.12 tomcat
```

* firewall 서비스 추가(firewall 사용한다면 해제 필요)
```
#firewall-cmd --permanent --add-port=8080/tcp
#firewall-cmd --reload
```

## httpd 설치
* 추후 버그나 취약점 시 버전 변경이 용의하도록 yum 설치 진행
```
#yum install -y httpd
```

* firewall 서비스 추가 (firewall을 사용한다면 해제 필요)
```
#firewall-cmd --permanent --add-service=http
#firewall-cmd --permanent --add-service=httpd
#firewall-cmd --reload
```


* html 소스 폴더 변경 (Optional)
```
#mkdir -p /app/http
#mv /var/www/* /app/http/
#chown -R apache:apache /app/http
#vi /etc/httpd/conf/httpd.conf

:%s:/var/www:/app/http:g 
:wq
```

* 로그 폴더 변경
```
#mkdir -p /app/http/logs
#mv /var/log/httpd/* /app/http/logs
#cd /etc/httpd/
#ln -sf /app/http/logs

chown -R apache:apache /app/http/logs
```

* systemd에 추가 및 시작
```
#systemctl enable httpd
#systemctl start httpd
``` 

## Tomcat Connector mod_jk 설치 및 설정
* 컴파일 툴 설치
```
#yum install gcc gcc-c++ 

```
* apxs(Tomcat Extension Tool) 설치
```
yum install httpd-devel pcre-devel
```

* mod_jk download (http://tomcat.apache.org/download-connectors.cgi에서 경로 확인)
```
#wget http://mirror.navercorp.com/apache/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.44-src.tar.gz
```

* mod_jk compile
```
#tar -xvf tomcat-connectors-1.2.44-src.tar.gz
#cd tomcat-connectors-1.2.44-src/native
#./configure --with-apxs=/usr/sbin/apxs  (/usr/bin/apxs일때도 있음 / 설치 버전별 다름)
#make && make install
```

* 확인
```
#ls -l /etc/httpd/modules/mod_jk.so
```

* SELinux 사용시 mod_jk.so 권한 추가
```
#chcon -u system_u -r object_r -t httpd_modules_t /etc/httpd/modules/mod_jk.so
```

* tomcat 폴더 권한 추가
```
#chcon -R --type=httpd_sys_rw_content_t /app/tomcat/webapp
#chown -R /app/tomcat/webapp
```

* Config 복사
```
#cp tomcat-connectors-1.2.44-src/conf/httpd-jk.conf /etc/httpd/conf.modules.d/
#cp tomcat-connectors-1.2.44-src/conf/workers.properties /etc/httpd/conf/
#cp tomcat-connectors-1.2.44-src/conf/uriworkermap.properties /etc/httpd/conf/
```

* httpd.conf 설정
```
#vi /etc/httpd/conf/httpd.conf
(추가)
LoadModule jk_module modules/mod_jk.so 

(수정)
DocumentRoot "/app/tomcat/webapps/ROOT"

(추가)
<Directory "/app/tomcat/webapps/ROOT">
    AllowOverride None
    Require all granted
</Directory>

```


* workers.properties 설정
```
(아래 부분을 설정에 맞게끔 수정)
worker.balancer.balance_workers=node1
worker.node1.reference=worker.template
worker.node1.host=localhost (IP변경)
worker.node1.port=8009
...
worker.balancer.balance_workers=node2
worker.node2.reference=worker.template
worker.node2.host=localhost (IP변경)
worker.node2.port=8009

```

* tomcat server.xml 수정
```
#vi /app/tomcat/conf/server.xml

(아래 jvmRoute= 에 worker name 과 동일하게 설정)
 <Engine name="Catalina" defaultHost="localhost" jvmRoute=node1>
 ```

* httpd-jk.conf 설정
```
(수정 / 공유 메모리파일 위치 반드시 Selinux 보안때문에 run에 위치 필수 )
JkShmFile run/mod_jk.shm
(수정 /로그 포맷에 사용할 시간 형식을 지정 )
JkLogStampFormat "[%y %m %d %H:%M:%S] "

(주석 해제)
JkMountFile conf/uriworkermap.properties
```

* uriworkermap.properties 수정
```
(추가)
/*=balancer  (worker.properties에 추가한 worker.list 명)
/*.jsp=balancer  (optional)
```

## 기타
* apache:tomcat 1:N구조 일때 방화벽 추가 설정
```
#firewall-cmd --permanent --add-port=8009/tcp
#firewall-cmd --permanent --add-port=8080/tcp

#firewall-cmd --list-port (확인)
```
