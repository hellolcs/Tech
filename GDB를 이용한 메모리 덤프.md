# GDB 를 이용한 메모리 덤프

* GDB 오픈
``` 
gdb /path/binary_name corefile 
```

* 변수명 및 주소 찾기
```
p *this (변수명)
```

* 메모리 덤프 하기
```
#dump memory /path/file_name start_address end_addres
dump memory /home/memory_dump 0x71239bf213 0x71239bf444
```