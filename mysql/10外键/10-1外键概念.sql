1 外键的概念
    如果公共关键字在一个关系中是主关键字,那么这个公共关键字被称为另一个关系的外键.
    由此可见,外键标识了两个关系之间的相关联系.以另一个关系的外键作为主关键字的表
    被称为主表,具有此外键的表被称为主表的从表.外键又称作外关键字.

    foreign key
    一张表(A)有一个字段,保存的值指向另一张表(B)的主键
    B: 主表
    A: 从表


2 增加外键
    注意:外键只能使用 innodb存储引擎,myisam不支持
        ALTER TABLE foreign1 ENGINE=INNODB;
        外键字段必须有约束,比如unique,primary key等

    先新建一张表作为外键
        CREATE TABLE `foreign0` (
        id int(11) NOT NULL AUTO_INCREMENT,
        class int(11) NOT NULL,
        PRIMARY KEY (id),
        UNIQUE KEY class (class) USING BTREE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    mysql中提供了两种方式增加外键
        a.再创建表的时候增加外键
            语法:在字段之后增加一条语句
            [constraint `外键名`] 可以自己定义外键名,不给的话系统默认有
            [constraint `外键名`] foreign key(外键字段) references 主表(主键)   ' ` '是反引号,[]代表可写
                测试:
                create table foreign1(
                    id int primary key auto_increment,
                    name varchar(10) not null,
                    -- 关联studnets2
                    class int,
                    -- 增加外键
                    constraint f_class foreign key(class) references foreign0(class)
                )charset utf8 ENGINE=INNODB;
                    desc foreign1;
                +-------+-------------+------+-----+---------+----------------+
                | Field | Type        | Null | Key | Default | Extra          |
                +-------+-------------+------+-----+---------+----------------+
                | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
                | name  | varchar(10) | NO   |     | NULL    |                |
                | class | int(11)     | YES  | MUL | NULL    |                |
                +-------+-------------+------+-----+---------+----------------+
            MUL 多索引,外键本身是一个索引,外键要求外键字段本身也是一种普通索引

                show create table foreign1;
                | foreign | CREATE TABLE `foreign` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `name` varchar(10) NOT NULL,
                `class` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`),
                KEY `class` (`class`)  //创建外键是自动增加的普通索引
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8 |

        b.在创建表之后增加外键
            alter table 从表 add constraint `外键名` foreign key(外键字段) references 主表(主键)

                //测试,将foreign2的class关联到students2的class
                alter table foreign2 add constraint f_class foreign key(class) references foreign0(class);
                desc foreign2;
                +-------+-------------+------+-----+---------+----------------+
                | Field | Type        | Null | Key | Default | Extra          |
                +-------+-------------+------+-----+---------+----------------+
                | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
                | name  | varchar(10) | NO   |     | NULL    |                |
                | class | int(11)     | YES  | MUL | NULL    |                |
                +-------+-------------+------+-----+---------+----------------+


3 修改&删除外键
    外键不允许修改,只能先删除,后增加
    语法: alter table 从表 drop foreign key '外键名'; //外键名是系统默认的或者自己增加的,反引号可加可不加

            测试:
            alter table foreign1 drop foreign key f_class;
            desc foreign2;
            +-------+-------------+------+-----+---------+----------------+
            | Field | Type        | Null | Key | Default | Extra          |
            +-------+-------------+------+-----+---------+----------------+
            | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
            | name  | varchar(10) | NO   |     | NULL    |                |
            | class | int(11)     | YES  | MUL | NULL    |                |
            +-------+-------------+------+-----+---------+----------------+
    还有MUL,外键创建会自动增加一层索引,但是外键删除只会删除自己,不会删除普通索引,所以还有MUL
    如果想删除对应的索引:alter table 从表 drop index 索引名字;

            alter table foreign2 drop index class;
            desc foreign2;
            +-------+-------------+------+-----+---------+----------------+
            | Field | Type        | Null | Key | Default | Extra          |
            +-------+-------------+------+-----+---------+----------------+
            | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
            | name  | varchar(10) | NO   |     | NULL    |                |
            | class | int(11)     | YES  |     | NULL    |                |
            +-------+-------------+------+-----+---------+----------------+
            没有MUL了


4 删除/更新行
行为 说明

NO ACTION       当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。 (与 RESTRICT 一致) 默认行为
RESTRICT        当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。 (与 NO ACTION 一致) 默认行为
CASCADE         当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有，则也删除/更新外键在子表中的记录。
SET NULL        当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为null（这就要求该外键允许取null）。
SET DEFAULT     父表有变更时，子表将外键列设置成一个默认的值 (Innodb不支持)

    具体语法为:
    alter table 表名 add constraint 外键名称 foreign key (外键字段) references 主表名 (主表字段名) on update cascade on delete cascade;
    alter table 表名 add constraint 外键名称 foreign key (外键字段) references 主表名 (主表字段名) on update set null on delete set null;


5 删除/更新行为
    (1) 外键字段需要保证与关联的主表的字段类型完全一致
    (2) 基本属性也要相同
    (3) 如果是在标后增加外键,对数据还有一定要求(从表数据与主表的关联关系)
    (4) 外键只能使用 innodb存储引擎,myisam不支持
