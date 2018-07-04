# bash 쉘스크립트 유용한 문법

* 라인별로 읽어서 편집하기
```
#!/bin/bash

# read line
while read line
do
	if [ "$line" == '' ]
	then
		echo 
		continue
	fi
	
	# doing
	time=`echo $line | cut -d',' -f3`
	echo "`date -d@$time +%F,%H:%M:%S`,$line"
done< ttt
```

* 붙여 넣기
```
(vim 내에서)
:set paste
```