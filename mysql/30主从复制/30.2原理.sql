1 原理
    MySQL主从复制的核心就是 二进制日志，具体的过程如下

    (PDF)

    从上图来看，复制分成三步：
        1. Master 主库在事务提交时，会把数据变更记录在二进制日志文件 Binlog 中。
        2. 从库读取主库的二进制日志文件 Binlog ，写入到从库的中继日志 Relay Log 。
        3. slave重做中继日志中的事件，将改变反映它自己的数据。
