1 md5()  对数据进行md5加密,MySQL中的内容和其他地方获得的结果完全相同

    select md5('ABCDEFG');
    +----------------------------------+
    | md5('ABCDEFG')                   |
    +----------------------------------+
    | bb747b3df3130fe1ca4afa93fb7d97c9 |
    +----------------------------------+


2 version()  获取版本号

    select version();
    +-----------+
    | version() |
    +-----------+
    | 8.0.12    |
    +-----------+


3 database()  显示当前数据库

    select database();
    +------------+
    | database() |
    +------------+
    | mb         |
    +------------+


4 UUID()  生成一个唯一标识符(自增长),自增长是单表唯一,uuid是全库唯一(数据唯一同时空间唯一)

    select uuid();
    +--------------------------------------+
    | uuid()                               |
    +--------------------------------------+
    | d81a1e40-070a-11eb-8e0c-80fa5b6064ee |
    +--------------------------------------+
