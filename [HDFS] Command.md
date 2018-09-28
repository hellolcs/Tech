# Command
### 상태 확인
- NameNode Status check
```
$ hadoop/bin/hdfs haadmin -getServiceState nn1
---------------------------------------
active

$ hadoop/bin/hdfs haadmin -getServiceState nn2
---------------------------------------
standby
```
- Console Report
```
$ hadoop/bin/hadoop dfsadmin -report
----------------------------------------
Configured Capacity: 0 (0 B)
Present Capacity: 0 (0 B)
DFS Remaining: 0 (0 B)
DFS Used: 0 (0 B)
DFS Used%: NaN%
Under replicated blocks: 0
Blocks with corrupt replicas: 0
Missing blocks: 0
Missing blocks (with replication factor 1): 0
Pending deletion blocks: 0
```

### FailOver
- Namenode 절체
```
$ hadoop/bin/hdfs haadmin -transitionToActive nn2
```
- 원복
```
$ hadoop/bin/hdfs haadmin -transitionToStandby nn2
$ hadoop/bin/hdfs haadmin -transitionToActive nn1
```

### 종료
- 개별 서버 종료
```
$ hadoop/sbin/hadoop-daemon.sh stop [namenode/datanode/journalnode/zkfc]
```

- 전체 서버 종료 (원격지 서버까지 종료됨)
```
$ hadoop/sbin/stop-all.sh
```

# Monitoring
### 모니터링 페이지
- http://url:50070/dfshealth.html