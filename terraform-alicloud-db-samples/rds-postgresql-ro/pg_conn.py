import psycopg2


def close_db_connection(conn):
    conn.commit()
    conn.close()


# Read-Write connection for primary instance
conn_rw = psycopg2.connect(database="test_database",
                           host="pgm-xxxxx.pg.rds.aliyuncs.com",
                           user="test_pg",
                           password="N1cetest",
                           port="5432",
                           target_session_attrs="read-write")
cur_rw = conn_rw.cursor()
cur_rw.execute("select pg_is_in_recovery(), pg_postmaster_start_time()")
row1 = cur_rw.fetchone()
print("recovery =", row1[0])
print("time =", row1[1])

# Read-Only connection for read-only instances
conn_ro = psycopg2.connect(database="test_database",
                           host="pgr-xxxxx1.pg.rds.aliyuncs.com,pgr-xxxxx2.pg.rds.aliyuncs.com",
                           user="test_pg",
                           password="N1cetest",
                           port="5432",
                           target_session_attrs="any")
cur_ro = conn_ro.cursor()
cur_ro.execute("select pg_is_in_recovery(), pg_postmaster_start_time()")
row2 = cur_ro.fetchone()
print("recovery =", row2[0])
print("time =", row2[1])

try:
    # Operation on Read-Write connection to the Primary instance
    cur_rw.execute("DROP TABLE IF EXISTS test_table")
    cur_rw.execute("CREATE TABLE test_table (id int)")
    cur_rw.execute("INSERT INTO test_table VALUES(1)")
    cur_rw.execute("INSERT INTO test_table VALUES(2)")
    cur_rw.execute("COMMIT")

    # Operation on Read-Only connection to the Read-Only instances
    cur_ro.execute("SELECT * FROM test_table")
    rows = cur_ro.fetchall()
    for row in rows:
        print('id=', row[0], '\n')

    cur_ro.execute("CREATE TABLE test_table (id int)")

except IOError as e:
    print(e)
    close_db_connection(conn_rw)
    close_db_connection(conn_ro)
else:
    close_db_connection(conn_rw)
    close_db_connection(conn_ro)
