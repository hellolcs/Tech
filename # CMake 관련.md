# CMake 관련

## compile 오류
* boost 라이브러리 경로가 이상할때 
```
cmake -DBoost_NO_BOOST_CMAKE=ON CMakeList.txt
```