import psycopg2
import time

conn = psycopg2.connect(
    database="test_database",
    user="test_pg",
    password="N1cetest",
    host="pgm-gs53181f3s2942pt64660.pgsql.singapore.rds.aliyuncs.com",
    port="5432"
)

cursor = conn.cursor()ß

sql = """CREATE TABLE IF NOT EXISTS student (
    id serial4 PRIMARY KEY,
    num int4,
    name varchar(25));"""
cursor.execute(sql)
print("Table student is created successfully.")

for num in range(1, 10000):
    try:
        sql = "INSERT INTO student (num, name) \
            VALUES (%s, '%s')" % \
            (num, str(num))
        print(sql)
        cursor.execute(sql)
        conn.commit()
        time.sleep(1)

    except Exception as e:
        conn.rollback()
        print(e)

conn.commit()
conn.close()
