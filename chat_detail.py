from flask import Flask, request
import pymysql
import pandas as pd

app = Flask(__name__)

# Student query
@app.route('/chat_detail', methods=['POST'])
def student_query():
    request_json = request.get_json()
    room_input = request_json['room_id']
    cust_input = request_json['cust_id']
    date_input = request_json['date']
    conn = pymysql.connect(host='localhost', port=3306, user='root',
                           password='qwerty1234', db='kakaotalk')

    # Query to count the number of members in the chat room
    sql_cnt = """
    SELECT count(*) cnt
    FROM T_chat_member
    WHERE room_id = %s
    """ % (room_input)
    df_cnt = pd.read_sql_query(sql_cnt, conn)

    # Query to retrieve chat details
    sql = """
    SELECT c.name, ifnull(p.url, "images/0.png") url, ch.chat,
           date_format(ch.chat_time, '%%p %%h:%%i') chat_time,
           if(c.cust_id = %s, 1, 0) me
    FROM T_chat ch
    JOIN T_customer c ON ch.cust_id = c.cust_id
    LEFT JOIN T_picture_update pu ON pu.cust_id = c.cust_id
    LEFT JOIN T_picture p ON pu.max_pic_id = p.pic_id
    WHERE room_id = %s
      AND date(chat_time) = '%s'
    ORDER BY ch.chat_id
    """ % (cust_input, room_input, date_input)
    df = pd.read_sql_query(sql, conn)

    # Prepare the response
    df_dict = {
        "room_id": room_input,
        "date": date_input,
        "count": df_cnt['cnt'].tolist()[0],
        "chats": {
            "chat": df['chat'].tolist(),
            "name": df['name'].tolist(),
            "image": df['url'].tolist(),
            "me": df['me'].tolist()
        }
    }

    return df_dict


if __name__ == "__main__":
    app.run()
