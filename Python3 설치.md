# Python 설치



### pyenv 설치
* 컴파일 환경 설치
```
yum install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel patch git tar
```
* pyenv 설치
```
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
```
* pyenv 환경 설정
```
echo >> /etc/profile
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /etc/profile
echo 'eval "$(pyenv init -)"' >> /etc/profile
echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile
source /etc/profile
```

### Python 설치
* 설치 가능 버전 확인
```
$pyenv install --list
Available versions:
  2.1.3
  2.2.3
  2.3.7
  2.4
  2.4.1
  2.4.2
  ...
```
* 설치
```
$pyenv install 3.6.2
Downloading Python-3.6.2.tar.xz...
-> https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
Installing Python-3.6.2...
Installed Python-3.6.2 to /root/.pyenv/versions/3.6.2

```

* 설치 된 버전 확인
```
$pyenv versions
* system (set by /root/.pyenv/version)
  3.6.2
```

* pyenv를 통한 python 버전 변경 (shell별로 적용됨)
```
$pyenv shell 3.6.2
```

* 바뀐 버전 확인
```
pyenv versions
  system
* 3.6.2 (set by PYENV_VERSION environment variable)
```