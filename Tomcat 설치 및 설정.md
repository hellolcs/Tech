#Httpd, Tomcat 설치 및 연동 설정

##JAVA 설치
* JAVA 설치 (추후 버전 관리가 용의하도록 tar 혹은 rpm으로 설치)
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
* JAVA 환경 설정
```
#vim /etc/profile
///맨아래 추가
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

#echo $JAVA_HOME (확인)
```

##Tomcat 설치
* Download(http://archive.apache.org/dist/tomcat/ 에서 버전 확인)
```
#wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.12/bin/apache-tomcat-9.0.12.tar.gz
#mkdir /app 
#mv apache-tomcat-9.0.12.tar.gz /app
#tar -xvf apache-tomcat-9.0.12.tar.gz
#ln -sf apache-tomcat-9.0.12 tomcat
```

##httpd 설치
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

* systemd에 추가