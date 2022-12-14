1 错误日志
    错误日志是 MySQL 中最重要的日志之一，它记录了当 mysqld 启动和停止时，以及服务器在运行过
    程中发生任何严重错误时的相关信息。当数据库出现任何故障导致无法正常使用时，建议首先查看此日志。

    该日志是默认开启的，默认存放目录 /var/log/，默认的日志文件名为 mysqld.log 。查看日志

    位置：
        show variables like '%log_error%';
        +---------------------+-------------------------------------------------+
        | Variable_name       | Value                                           |
        +---------------------+-------------------------------------------------+
        | binlog_error_action | ABORT_SERVER                                    |
        | log_error           | D:\phpstudy_pro\Extensions\MySQL8.0.12\data.err |
        | log_error_services  | log_filter_internal; log_sink_internal          |
        | log_error_verbosity | 1                                               |
        +---------------------+-------------------------------------------------+
