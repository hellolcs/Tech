## DataNode
- Incompatible ClusterIDs 오류
  * NameNode와 DataNode의 ID 불일치로 발생
  * 보통 "hadoop namenode -format" 시 namenode는 새로운 ID발급, datanode는 기존 ID사용으로 인해 발생
  * namenode format 전 datanode의 Data Node Directory(hadoop/repository/dfs/datanode/current) 내 VERSION 파일을 삭제 하고 format 진행
