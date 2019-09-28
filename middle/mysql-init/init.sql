
-- 可以在此文件中添加初始化sql

set names utf8;

create database init_database DEFAULT CHARSET utf8mb4;

use init_database;

create table init_table(
        id bigint(20) default null comment '初始化表'
);
