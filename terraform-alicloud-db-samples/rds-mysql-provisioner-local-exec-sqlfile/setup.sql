DROP TABLE if exists t_order;

CREATE TABLE t_order(
    order_id bigint,
    user_id smallint,
    info text,
    c1 smallint,
    crt_time timestamp,
PRIMARY KEY ( order_id ));

GRANT select on test_database.* to test_mysql_1@'%';
GRANT insert on test_database.* to test_mysql_1@'%';
GRANT update on test_database.* to test_mysql_1@'%';
GRANT delete on test_database.* to test_mysql_1@'%';

GRANT select on test_database.* to test_mysql_2@'%';