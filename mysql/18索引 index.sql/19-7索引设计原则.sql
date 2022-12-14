1 索引设计原则
    1). 针对于数据量较大，且查询比较频繁的表建立索引。
        只插入不查询不需要index,因为index是为了查询优化的

    2). 针对于常作为查询条件（where）、排序（order by）、分组（group by）操作的字段建立索引。

    3). 尽量选择区分度高的列作为索引，尽量建立唯一索引，区分度越高，使用索引的效率越高。
        状态字段,比如性别,是否删除,建立索引效果不明显

    4). 如果是字符串类型的字段，字段的长度较长，可以针对于字段的特点，建立前缀索引。
        create index idx_email_5 on m_tb_user(email(5)); email前5个字符

    5). 尽量使用联合索引，减少单列索引，查询时，联合索引很多时候可以覆盖索引，节省存储空间，避免回表，提高查询效率。
        联合索引注意字段前后顺序,注意最左前缀法则,查询时查询前面的字段才会用到联合索引

    6). 要控制索引的数量，索引并不是多多益善，索引越多，维护索引结构的代价也就越大，会影响增删改的效率。

    7). 如果索引列不能存储NULL值，请在创建表时使用NOT NULL约束它。当优化器知道每列是否包含NULL值时，它可以更好地确定哪个索引最有效地用于查询。
