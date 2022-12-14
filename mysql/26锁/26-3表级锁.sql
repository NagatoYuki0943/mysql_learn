1 介绍
    表级锁，每次操作锁住整张表。锁定粒度大，发生锁冲突的概率最高，并发度最低。应用在MyISAM、
    InnoDB、BDB等存储引擎中。

    对于表级锁，主要分为以下三类：
        - 表锁
        - 元数据锁（meta data lock，MDL）
        - 意向锁


2 表锁
    对于表锁，分为两类：
        - 表共享读锁（read lock）
        - 表独占写锁（write lock）


    语法：
        - 加锁：lock tables 表名,... read/write。
        - 释放锁：unlock tables / 客户端断开连接 。


    特点:
        A. 读锁(阻止自己和他人写入,不阻止读取)
            左侧为客户端一，对指定表加了读锁，不会影响右侧客户端二的读，但是会阻塞右侧客户端的写。
            测试:
            左侧:
                lock table user read;
                Query OK, 0 rows affected (0.00 sec)
                select * from user;
                +-----+-----------------+----------+--------+---------------------+---------------------+------------+
                | id  | username        | password | gender | create_time         | update_time         | deleted_at |
                +-----+-----------------+----------+--------+---------------------+---------------------+------------+
                |  19 | 蜡笔小新        | 123      | 男     | NULL                | NULL                | NULL       |
                ...
                | 242 | 狼狼            | 123456   | 男     | 2021-03-07 12:38:28 | 2021-03-07 12:45:36 | NULL       |
                | 243 | cc              | 123456   | 男     | 2021-03-07 12:47:23 | 2021-03-07 12:47:36 | NULL       |
                +-----+-----------------+----------+--------+---------------------+---------------------+------------+
                update user set username='ccc' where id=243;
                ERROR 1099 (HY000): Table 'user' was locked with a READ lock and can t be updated

            右侧: -- 可以读取不能写入
                select * from user;
                +-----+-----------------+----------+--------+---------------------+---------------------+------------+
                | id  | username        | password | gender | create_time         | update_time         | deleted_at |
                +-----+-----------------+----------+--------+---------------------+---------------------+------------+
                |  19 | 蜡笔小新        | 123      | 男     | NULL                | NULL                | NULL       |
                ...
                | 242 | 狼狼            | 123456   | 男     | 2021-03-07 12:38:28 | 2021-03-07 12:45:36 | NULL       |
                | 243 | cc              | 123456   | 男     | 2021-03-07 12:47:23 | 2021-03-07 12:47:36 | NULL       |
                +-----+-----------------+----------+--------+---------------------+---------------------+------------+
                update user set username='ccc' where id=243; -- 卡住,直到锁解除
                Query OK, 1 row affected (51.25 sec)
                Rows matched: 1  Changed: 1  Warnings: 0


        B. 写锁(阻止其他人读取和写入,自己能写入和读取)
            左侧为客户端一，对指定表加了写锁，会阻塞右侧客户端的读和写。
            测试:
            左侧:
                lock table user write;
                select * from user limit 1;
                +----+--------------+----------+--------+-------------+-------------+------------+
                | id | username     | password | gender | create_time | update_time | deleted_at |
                +----+--------------+----------+--------+-------------+-------------+------------+
                | 19 | 蜡笔小新     | 123      | 男     | NULL        | NULL        | NULL       |
                +----+--------------+----------+--------+-------------+-------------+------------+

                mysql> update user set password=1234 where id=19;
                Query OK, 1 row affected (0.43 sec)
                Rows matched: 1  Changed: 1  Warnings: 0

            右侧: --写入和读取都会被阻止
                select * from user limit 1;
                ^C -- query aborted
                ERROR 1317 (70100): Query execution was interrupted
                mysql> update user set password=1234 where id=19;
                Query OK, 0 rows affected (13.03 sec)
                Rows matched: 1  Changed: 0  Warnings: 0

    结论: 读锁不会阻塞其他客户端的读，但是会阻塞写。写锁既会阻塞其他客户端的读，又会阻塞
    其他客户端的写。


3 元数据锁
    meta data lock , 元数据锁，简写MDL。
    MDL加锁过程是系统自动控制，无需显式使用，在访问一张表的时候会自动加上。MDL锁主要作用是维
    护表元数据的数据一致性，在表上有活动事务的时候，不可以对元数据进行写入操作。为了避免DML与
    DDL冲突，保证读写的正确性。

    这里的元数据，大家可以简单理解为就是一张表的表结构。 也就是说，某一张表涉及到未提交的事务
    时，是不能够修改这张表的表结构的。

    在MySQL5.5中引入了MDL，当对一张表进行增删改查的时候，加MDL读锁(共享)；当对表结构进行变
    更操作的时候，加MDL写锁(排他)。
    常见的SQL操作时，所添加的元数据锁：

        对应SQL                                         锁类型                                      说明
        lock tables xxx read / write                    SHARED_READ_ONLY / SHARED_NO_READ_WRITE

        select、select ... lock in share mode           SHARED_READ                                 与SHARED_READ、SHARED_WRITE兼容，与EXCLUSIVE互斥

        insert、update、delete、select ... for update   SHARED_WRITE                                与SHARED_READ、SHARED_WRITE兼容，与EXCLUSIVE互斥

        alter table ...                                 EXCLUSIVE                                   与其他的MDL都互斥

    查询,写入,修改,删除都可以兼容,不过 alter 修改数据表结构不兼容

    演示：
        当执行SELECT、INSERT、UPDATE、DELETE等语句时，添加的是元数据共享锁（SHARED_READ / SHARED_WRITE），之间是兼容的。

        当执行SELECT语句时，添加的是元数据共享锁（SHARED_READ），会阻塞元数据排他锁 （EXCLUSIVE），之间是互斥的。

        我们可以通过下面的SQL，来查看数据库中的元数据锁的情况：

            select object_type,object_schema,object_name,lock_type,lock_duration from performance_schema.metadata_locks;
            +-------------------+--------------------+----------------+---------------------+---------------+
            | object_type       | object_schema      | object_name    | lock_type           | lock_duration |
            +-------------------+--------------------+----------------+---------------------+---------------+
            | TABLE             | performance_schema | metadata_locks | SHARED_READ         | TRANSACTION   |
            | SCHEMA            | performance_schema | NULL           | INTENTION_EXCLUSIVE | TRANSACTION   |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            | COLUMN STATISTICS | performance_schema | metadata_locks | SHARED_READ         | STATEMENT     |
            +-------------------+--------------------+----------------+---------------------+---------------+
            13 rows in set (0.24 sec)

        我们在操作过程中，可以通过上述的SQL语句，来查看元数据锁的加锁情况。


4 意向锁
    1). 介绍 (PDF)
        为了避免DML在执行时，加的行锁与表锁的冲突，在InnoDB中引入了意向锁，使得表锁不用检查每行
        数据是否加锁，使用意向锁来减少表锁的检查。

        假如没有意向锁，客户端一对表加了行锁后，客户端二如何给表加表锁呢，来通过示意图简单分析一下：
        首先客户端一，开启一个事务，然后执行DML操作，在执行DML语句时，会对涉及到的行加行锁。

        当客户端二，想对这张表加表锁时，会检查当前表是否有对应的行锁，如果没有，则添加表锁，此时就
        会从第一行数据，检查到最后一行数据，效率较低。

        有了意向锁之后 :
        客户端一，在执行DML操作时，会对涉及的行加行锁，同时也会对该表加上意向锁。

        而其他客户端，在对这张表加表锁的时候，会根据该表上所加的意向锁来判定是否可以成功加表锁，而
        不用逐行判断行锁情况了。

    2). 分类
        - 意向共享锁(IS): 由语句select ... lock in share mode添加 。 与 表锁共享锁(read)兼容，与表锁排他锁(write)互斥。
        - 意向排他锁(IX): 由insert、update、delete、select...for update添加 。与表锁共享锁(read)及排他锁(write)都互斥，意向锁之间不会互斥。

        一旦事务提交了，意向共享锁、意向排他锁，都会自动释放。

        可以通过以下SQL，查看意向锁及行锁的加锁情况：


        A. 意向共享锁与表读锁是兼容的
            左侧:
                begin; -- 开启事务

                select * from students1 where id=1 lock in share mode;
                +----+--------+------+------+-------+-------+
                | id | name   | sex  | age  | class | score |
                +----+--------+------+------+-------+-------+
                |  1 | 赵一   | male |   15 |     1 |    58 |
                +----+--------+------+------+-------+-------+
                1 row in set (0.00 sec)

                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                +---------------+-------------+------------+-----------+-----------+-----------+
                | object_schema | object_name | index_name | lock_type | lock_mode | lock_data |
                +---------------+-------------+------------+-----------+-----------+-----------+
                | mb            | students1   | NULL       | TABLE     | IS        | NULL      |    -- IS 意向共享锁
                | mb            | students1   | PRIMARY    | RECORD    | S         | 1         |    -- RECORD 行锁
                +---------------+-------------+------------+-----------+-----------+-----------+
                2 rows in set (0.00 sec)

                commit;

            右侧:
                lock tables students1 read;     -- 加读锁成功,因为IS意向共享锁和read锁兼容
                Query OK, 0 rows affected (0.00 sec)

                lock tables students1 write;    -- 卡出,write和IS不兼容
                Query OK, 0 rows affected (47.46 sec)


            B. 意向排他锁与表读锁、写锁都是互斥的

            左侧:
                begin;

                update students1 set score=60 where id=1;
                Query OK, 1 row affected (12.29 sec)
                Rows matched: 1  Changed: 1  Warnings: 0

                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                +---------------+-------------+------------+-----------+-----------+-----------+
                | object_schema | object_name | index_name | lock_type | lock_mode | lock_data |
                +---------------+-------------+------------+-----------+-----------+-----------+
                | mb            | students1   | NULL       | TABLE     | IX        | NULL      |    --IX 意向排他锁
                | mb            | students1   | PRIMARY    | RECORD    | X         | 1         |    --X  排他锁
                +---------------+-------------+------------+-----------+-----------+-----------+

            右侧:
                lock tables students1 read; -- 卡住,read或者write锁和IX互斥
