from flask import Flask, request
import pymysql
import pandas as pd

app = Flask(__name__)

# Student query
@app.route('/friend_list', methods=['POST'])
def student_query():
    request_json = request.get_json()
    cust_input = request_json['cust_id']
    conn = pymysql.connect(host='localhost', port=3306, user='root',
                           password='qwerty1234', db='kakaotalk')
    sql = """
    SELECT c.name, ifnull(p.url, "images/0.png") url
    FROM T_friend f
    JOIN T_customer c ON f.friend_id = c.cust_id
    LEFT JOIN T_picture_update pu ON c.cust_id = pu.cust_id
    LEFT JOIN T_picture p ON pu.max_pic_id = p.pic_id
    WHERE f.cust_id = %s
    ORDER BY c.name;
    """
    df = pd.read_sql_query(sql, conn, params=[cust_input])
    df_dict = {"name": df['name'].tolist(), "image": df['url'].tolist()}
    return df_dict

if __name__ == "__main__":
    app.run()
