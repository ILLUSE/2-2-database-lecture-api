use kakaotalk;
/*
create table T_customer (cust_id int, name varchar(10), birthday timestamp);
create table T_friend (cust_id int, friend_id int);
create table T_picture (pic_id int, cust_id int, url varchar(20), update_time timestamp);
create table T_chat (chat_id int, room_id int, cust_id int,chat varchar(300), chat_time timestamp);
create table T_chat_member (room_id int, cust_id int);
*/

-- Week11_2_DB_Database design workshop2-3.pdf
/*
-- 채팅방 명 수
select room_id , count(*) cnt
from T_chat_member
where room_id = 1;
*/

/*
-- 날짜별 채팅
select *
from T_chat
where room_id = 1
and date(chat_time) = '2023-09-29'; -- 날짜형으로 바꿔주어야함!
*/

/*
-- 내가 누군지 체크
select cu.name , ifnull(p.url,"images/0.png") , c.chat ,c.chat_time,if(cu.cust_id = 2,1,0) Me
from T_chat c
join T_customer cu on c.cust_id = cu.cust_id
left join T_picture_update pu on pu.cust_id = cu.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where c.room_id = 1 and date(chat_time) = '2023-09-29'
order by c.chat_id;
*/
/*
-- 시간순대로 채팅방 정렬
select room_id,max(chat_id) current_chat_id -- chat_id 가 이미 정렬되어있어 그걸 이용
from T_chat
group by room_id;

select *
from T_chat c
join(
select room_id,max(chat_id) chat_id
from T_chat
group by room_id
) max_ch on c.chat_id = max_ch.chat_id
order by c.chat_id desc;
*/
/*
-- 여러명 방인 경우 ********
select chm.room_id , group_concat(c.name) names ,count(*) cnt-- group_concat : group 안에 있는 요소들 묶어주는 것
from T_chat_member chm
join T_customer c on chm.cust_id = c.cust_id
where c.cust_id != 2 -- 자기 자신은 뺌
group by chm.room_id;

select chm.room_id , count(*) cnt ,
group_concat(c.name) names_full, -- 풀 이름들 1,2명일때 출력
substring_index(group_concat(c.name),',',3) names_3, -- 3명일때 출력
concat(substring_index(group_concat(c.name),',',3),'...') -- names_3_concat 3명이상일때 출력
from T_chat_member chm
join T_customer c on chm.cust_id = c.cust_id
where c.cust_id != 2 -- 자기 자신은 뺌
group by chm.room_id;

select a.room_id,if(cnt > 3, names_3_concat,names_3) names
from(
select chm.room_id , count(*) cnt ,
group_concat(c.name) names_full, -- 풀 이름들
substring_index(group_concat(c.name),',',3) names_3, -- 1 ~ 3명일때 출력
concat(substring_index(group_concat(c.name),',',3),'...') names_3_concat -- 3명이상일때 출력
from T_chat_member chm
join T_customer c on chm.cust_id = c.cust_id
where c.cust_id != 2 -- 자기 자신은 뺌
group by chm.room_id
) a;

select a.room_id,if(cnt > 3, names_3_concat,names_3) names , ch.chat,
date_format(ch.chat_time, '%m-%d %p %h:%i') chat_time -- %p : am/pm 나타냄
from(
select chm.room_id , count(*) cnt ,
group_concat(c.name) names_full, -- 풀 이름들
substring_index(group_concat(c.name),',',3) names_3, -- 1 ~ 3명일때 출력
concat(substring_index(group_concat(c.name),',',3),'...') names_3_concat -- 3명이상일때 출력
from T_chat_member chm
join T_customer c on chm.cust_id = c.cust_id
where c.cust_id != 2 -- 자기 자신은 뺌
group by chm.room_id
) a
join ( -- 가장 최근 올라온 챗 기준 방 번호
select room_id , max(chat_id) chat_id
from T_chat
group by room_id
) b on a.room_id = b.room_id
join T_chat ch on b.chat_id = ch.chat_id
order by ch.chat_id desc;
*/

