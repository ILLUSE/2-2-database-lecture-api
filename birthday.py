from flask import Flask, request
import pymysql
import pandas as pd

app = Flask(__name__)

# Student query
@app.route('/birthday', methods=['POST'])
def student_query():
    request_json = request.get_json()
    cust_input = request_json['cust_id']
    conn = pymysql.connect(host='localhost', port=3306, user='root',
                           password='qwerty1234', db='kakaotalk')

    # Query for friends with today's birthday
    sql_today = """
    SELECT c.name, ifnull(p.url, "images/0.png") url
    FROM T_friend f
    JOIN T_customer c ON f.friend_id = c.cust_id
    LEFT JOIN T_picture_update pu ON c.cust_id = pu.cust_id
    LEFT JOIN T_picture p ON pu.max_pic_id = p.pic_id
    WHERE f.cust_id = %s
      and month(c.birthday) = month(curdate())
      and day(c.birthday) = day(curdate());
    """ % cust_input
    df_today = pd.read_sql_query(sql_today, conn)

    # Query for friends with birthdays in the past 30 days
    sql_past = """
    SELECT c.name, c.birthday, ifnull(p.url, "images/0.png") url
    FROM T_friend f
    JOIN T_customer c ON f.friend_id = c.cust_id
    LEFT JOIN T_picture_update pu ON c.cust_id = pu.cust_id
    LEFT JOIN T_picture p ON pu.max_pic_id = p.pic_id
    WHERE f.cust_id = %s
      and date_format(c.birthday, '2024-%%m-%%d')
      between date_add(curdate(), interval -30 day) and curdate()
    ORDER BY date_format(c.birthday, '2024-%%m-%%d'), c.name;
    """ % cust_input
    df_past = pd.read_sql_query(sql_past, conn)

    # Query for friends with birthdays in the coming 30 days
    sql_coming = """
    SELECT c.name, c.birthday, ifnull(p.url, "images/0.png") url
    FROM T_friend f
    JOIN T_customer c ON f.friend_id = c.cust_id
    LEFT JOIN T_picture_update pu ON c.cust_id = pu.cust_id
    LEFT JOIN T_picture p ON pu.max_pic_id = p.pic_id
    WHERE f.cust_id = %s
      and date_format(c.birthday, '2024-%%m-%%d')
      between curdate() and date_add(curdate(), interval 30 day)
    ORDER BY date_format(c.birthday, '2024-%%m-%%d'), c.name;
    """ % cust_input
    df_coming = pd.read_sql_query(sql_coming, conn)

    # Combine results into a dictionary
    df_dict = {
        "today": {"name": df_today['name'].tolist(), "image": df_today['url'].tolist()},
        "past": {"name": df_past['name'].tolist(), "image": df_past['url'].tolist()},
        "coming": {"name": df_coming['name'].tolist(), "image": df_coming['url'].tolist()}
    }
    return df_dict


if __name__ == "__main__":
    app.run()
