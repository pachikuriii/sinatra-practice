CREATE DATABASE memos;
CREATE TABLE Memo
(memo_id VARCHAR(40) NOT NULL,
memo_title VARCHAR(20) NOT NULL,
memo_content VARCHAR(200) NOT NULL,
PRIMARY KEY (memo_id));