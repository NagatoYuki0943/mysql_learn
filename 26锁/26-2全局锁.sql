1 介绍
    全局锁就是对整个数据库实例加锁，加锁后整个实例就处于只读状态，后续的DML的写语句，DDL语
    句，已经更新操作的事务提交语句都将被阻塞。

    其典型的使用场景是做全库的逻辑备份，对所有的表进行锁定，从而获取一致性视图，保证数据的完整
    性。

    为什么全库逻辑备份，就需要加全就锁呢？ (PDF)

    A. 我们一起先来分析一下不加全局锁，可能存在的问题。
        假设在数据库中存在这样三张表: tb_stock 库存表，tb_order 订单表，tb_orderlog 订单日志表。
            - 在进行数据备份时，先备份了tb_stock库存表。
            - 然后接下来，在业务系统中，执行了下单操作，扣减库存，生成订单（更新tb_stock表，插入tb_order表）。
            - 然后再执行备份 tb_order表的逻辑。
            - 业务中执行插入订单日志操作。
            - 最后，又备份了tb_orderlog表。

        此时备份出来的数据，是存在问题的。因为备份出来的数据，tb_stock表与tb_order表的数据不一
        致(有最新操作的订单信息,但是库存数没减)。
        那如何来规避这种问题呢? 此时就可以借助于MySQL的全局锁来解决。

    B. 再来分析一下加了全局锁后的情况
        对数据库进行进行逻辑备份之前，先对整个数据库加上全局锁，一旦加了全局锁之后，其他的DDL、
        DML全部都处于阻塞状态，但是可以执行DQL语句，也就是处于只读状态，而数据备份就是查询操作。
        那么数据在进行逻辑备份的过程中，数据库中的数据就是不会发生变化的，这样就保证了数据的一致性
        和完整性


2 语法
    1). 加全局锁
        flush tables with read lock;
        Query OK, 0 rows affected (0.00 sec)

        这时在另一个终端操作
        update user set name='ccc' where id=243;
        会一直卡住

    2). 数据备份
        -- 这个命令不要在sql中运行,要在系统终端中运行
        mysqldump -uroot –proot mb > mb.sql;

    数据备份的相关指令, 在后面MySQL管理章节, 还会详细讲解.

    3). 释放锁
        unlock tables;


3 特点
    数据库中加全局锁，是一个比较重的操作，存在以下问题：
        - 如果在主库上备份，那么在备份期间都不能执行更新，业务基本上就得停摆。
        - 如果在从库上备份，那么在备份期间从库不能执行主库同步过来的二进制日志（binlog），会导致主从延迟。

    在InnoDB引擎中，我们可以在备份时加上参数 --single-transaction 参数来完成不加锁的一致
    性数据备份。
        mysqldump --single-transaction -uroot –p123456 itcast > itcast.sql

