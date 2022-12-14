1 概述
    select count(*) from m_tb_user;

    在之前的测试中，我们发现，如果数据量很大，在执行count操作时，是非常耗时的。

    - MyISAM 引擎把一个表的总行数存在了磁盘上，因此执行 count(*) 的时候会直接返回这个数，效率很高； 但是如果是带条件的count，MyISAM也慢。
    - InnoDB 引擎就麻烦了，它执行 count(*) 的时候，需要把数据一行一行地从引擎里面读出来，然后累积计数。

    如果说要大幅度提升InnoDB表的count效率，主要的优化思路：自己计数(可以借助于redis这样的数
    据库进行,但是如果是带条件的count又比较麻烦了)。


2 count用法
    count() 是一个聚合函数，对于返回的结果集，一行行地判断，如果 count 函数的参数不是
    NULL，累计值就加 1，否则不加，最后返回累计值。

    用法：count（*）、count（主键）、count（字段）、count（数字）

    count用法           含义
    count(主键)     InnoDB 引擎会遍历整张表，把每一行的 主键id 值都取出来，返回给服务层。
                    服务层拿到主键后，直接按行进行累加(主键不可能为null)

    count(字段)     没有not null 约束 : InnoDB 引擎会遍历整张表把每一行的字段值都取出
                    来，返回给服务层，服务层判断是否为null，不为null，计数累加。
                    有not null 约束：InnoDB 引擎会遍历整张表把每一行的字段值都取出来，返
                    回给服务层，直接按行进行累加。

    count(数字)     InnoDB 引擎遍历整张表，但不取值。服务层对于返回的每一行，放一个数字“1”
                    进去，直接按行进行累加。

    count(*)        InnoDB引擎并不会把全部字段取出来，而是专门做了优化，不取值，服务层直接
                    按行进行累加。


    按照效率排序的话，count(字段) < count(主键 id) < count(1) ≈ count(*)，所以尽量使用 count(*)。

    select count(name) from m_tb_user;
    +-------------+
    | count(name) |
    +-------------+
    |          24 |
    +-------------+
    1 row in set (0.03 sec)

    select count(id) from m_tb_user;
    +-----------+
    | count(id) |
    +-----------+
    |        24 |
    +-----------+
    1 row in set (0.06 sec)

    select count(1) from m_tb_user;
    +----------+
    | count(1) |
    +----------+
    |       24 |
    +----------+
    1 row in set (0.03 sec)

    select count(*) from m_tb_user;
    +----------+
    | count(*) |
    +----------+
    |       24 |
    +----------+
    1 row in set (0.05 sec)