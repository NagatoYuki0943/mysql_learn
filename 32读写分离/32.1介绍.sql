1 介绍
    读写分离,简单地说是把对数据库的读和写操作分开,以对应不同的数据库服务器。主数据库提供写操
    作，从数据库提供读操作，这样能有效地减轻单台数据库的压力。
    通过MyCat即可轻易实现上述功能，不仅可以支持MySQL，也可以支持Oracle和SQL Server。

