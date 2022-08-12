1 自动事务
    autocommit 当客户端发送一条sql指令(写操作:增删改)给服务器的时候,
    在服务器执行的之后,不用等待用户反馈结果,对自动将结果同步到数据表.

    证明:利用两个客户端,一个执行sql指令,另一个客户端查看结果

2 自动事务:系统做了额外的步骤来帮助用户操作,系统通过变量来控制.Autocommit
    show variables like 'autocommit';
    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | autocommit    | ON    | ON代表开启
    +---------------+-------+

    select @@autocommit;
    +--------------+
    | @@autocommit |
    +--------------+
    |            1 |
    +--------------+


3 关闭自动事务,系统就不会帮用户提交结果了
    --关闭事务
    set autocommit = 0/off;
    set @@autocommit = 0/off;
    --开启事务
    set autocommit = 1/on;
    set @@autocommit = 1/on;


        测试:
        一个客户端插入,在另一个客户端看不到新数据

    一旦自动事务关闭,那么需要用户提供是否同步的命令
    直接键入即可
    commit;     提交(同步到数据表,事务也被清空)
    rollback;   回滚(清空之前的操作,不要了)

    在自己的客户端插入数据但是还没提交之后,系统在进行数据查看的时候会
    利用事务日志中保存的结果对数据进行加工

4 通常不会关闭自动事务,太麻烦.因此只会在需要事务处理的时候才会进行操作(手动事务)