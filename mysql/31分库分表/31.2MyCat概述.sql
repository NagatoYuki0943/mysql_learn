1 介绍
    Mycat是开源的、活跃的、基于Java语言编写的MySQL数据库中间件。可以像使用mysql一样来使用
    mycat，对于开发人员来说根本感觉不到mycat的存在。

    开发人员只需要连接MyCat即可，而具体底层用到几台数据库，每一台数据库服务器里面存储了什么数
    据，都无需关心。 具体的分库分表的策略，只需要在MyCat中配置即可。
    (PDF)
    优势：
        - 性能可靠稳定
        - 强大的技术团队
        - 体系完善
        - 社区活


2 下载
    下载地址：http://dl.mycat.org.cn/


3 安装
    Mycat是采用java语言开发的开源的数据库中间件，支持Windows和Linux运行环境，下面介绍
    MyCat的Linux中的环境搭建。我们需要在准备好的服务器中安装如下软件。
    - MySQL
    - JDK
    - Mycat

    服务器          安装软件     说明
    192.168.200.210 JDK、Mycat  MyCat中间件服务器
    192.168.200.210 MySQL       分片服务器
    192.168.200.213 MySQL       分片服务器
    192.168.200.214 MySQL       分片服务器

    具体的安装步骤： 参考资料中提供的 《MyCat安装文档》即可，里面有详细的安装及配置步骤。


4 目录介绍
    bin : 存放可执行文件，用于启动停止mycat
    conf：存放mycat的配置文件
    lib： 存放mycat的项目依赖包（jar）
    logs：存放mycat的日志文件


5 概念介绍 (PDF)
    在MyCat的整体结构中，分为两个部分：上面的逻辑结构、下面的物理结构。

    在MyCat的逻辑结构主要负责逻辑库、逻辑表、分片规则、分片节点等逻辑结构的处理，而具体的数据
    存储还是在物理结构，也就是数据库服务器中存储的。
    在后面讲解MyCat入门以及MyCat分片时，还会讲到上面所提到的概念。

