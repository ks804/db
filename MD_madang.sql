DROP TABLE reservation CASCADE CONSTRAINT;
DROP TABLE theater CASCADE CONSTRAINT;
DROP TABLE customer CASCADE CONSTRAINT;
DROP TABLE cinema CASCADE CONSTRAINT;

CREATE TABLE cinema (
    cinemaid NUMBER PRIMARY KEY,
    cinema_name VARCHAR2(100) NOT NULL,
    cinema_location VARCHAR2(100)
);

CREATE TABLE theater (
    cinemaid NUMBER,
    theaterid NUMBER,
    movietitle VARCHAR2(200) NOT NULL,
    price NUMBER,
    seat_num NUMBER,
    CONSTRAINT pk_theater PRIMARY KEY (cinemaid, theaterid),
    CONSTRAINT fk_theater_cinema FOREIGN KEY (cinemaid) REFERENCES cinema(cinemaid)
);

CREATE TABLE customer (
    customerid NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    customer_address VARCHAR2(200)
);

CREATE TABLE reservation (
    cinemaid    NUMBER,
    theaterid   NUMBER,
    customerid  NUMBER,
    seatid      NUMBER,
    dateid      DATE,
    CONSTRAINT pk_reservation PRIMARY KEY (cinemaid, theaterid, customerid),
    CONSTRAINT fk_reservation_theater FOREIGN KEY (cinemaid, theaterid) 
                                      REFERENCES theater(cinemaid, theaterid),
    CONSTRAINT fk_reservation_customer FOREIGN KEY (customerid) 
                                       REFERENCES customer(customerid)
);

INSERT INTO cinema VALUES (1, '강남극장', '강남');
INSERT INTO cinema VALUES (2, '강동극장', '강동');
INSERT INTO cinema VALUES (3, '홍대극장', '마포');
INSERT INTO cinema VALUES (4, '신촌극장', '서대문');
INSERT INTO cinema VALUES (5, '잠실극장', '송파');

INSERT INTO theater VALUES (1, 1, '아바타', 12000, 150);
INSERT INTO theater VALUES (1, 2, '범죄도시4', 11000, 120);
INSERT INTO theater VALUES (1, 3, '파묘', 9000, 80);
INSERT INTO theater VALUES (2, 1, '듄2', 13000, 200);
INSERT INTO theater VALUES (2, 2, '건국전쟁', 8000, 60);
INSERT INTO theater VALUES (3, 1, '오펜하이머', 12000, 180);
INSERT INTO theater VALUES (3, 2, '서울의봄', 10000, 100);
INSERT INTO theater VALUES (3, 3, '밀수', 9000, 90);
INSERT INTO theater VALUES (4, 1, '콘크리트유토피아', 11000, 130);
INSERT INTO theater VALUES (4, 2, '외계+인', 7000, 70);
INSERT INTO theater VALUES (5, 1, '탑건매버릭', 13000, 250);
INSERT INTO theater VALUES (5, 2, '앤트맨', 10000, 110);

INSERT INTO customer VALUES (1, '김철수', '서울시 강남구 역삼동');
INSERT INTO customer VALUES (2, '이영희', '서울시 강동구 천호동');
INSERT INTO customer VALUES (3, '박민준', '서울시 마포구 홍대동');
INSERT INTO customer VALUES (4, '최수연', '서울시 서대문구 신촌동');
INSERT INTO customer VALUES (5, '정하늘', '서울시 송파구 잠실동');
INSERT INTO customer VALUES (6, '한지민', '서울시 강북구 수유동');
INSERT INTO customer VALUES (7, '강감찬', '서울시 용산구 이태원동');
INSERT INTO customer VALUES (8, '장내윤', '서울시 성동구 왕십리동');

INSERT INTO reservation VALUES (1, 1, 1, 15, TO_DATE('2024-10-01', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (1, 1, 2, 23, TO_DATE('2024-10-01', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (1, 2, 3, 7, TO_DATE('2024-10-05', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (1, 3, 4, 11, TO_DATE('2024-10-05', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (2, 1, 1, 50, TO_DATE('2024-10-10', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (2, 1, 5, 88, TO_DATE('2024-10-10', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (2, 2, 6, 3, TO_DATE('2024-10-12', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (3, 1, 2, 77, TO_DATE('2024-10-15', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (3, 2, 7, 45, TO_DATE('2024-10-15', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (3, 3, 8, 62, TO_DATE('2024-10-18', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (4, 1, 3, 19, TO_DATE('2024-10-20', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (4, 2, 4, 33, TO_DATE('2024-10-20', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 1, 5, 100, TO_DATE('2024-10-22', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 1, 6, 120, TO_DATE('2024-10-22', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 2, 7, 55, TO_DATE('2024-10-25', 'YYYY-MM-DD'));
INSERT INTO reservation VALUES (5, 2, 8, 67, TO_DATE('2024-10-25', 'YYYY-MM-DD'));
COMMIT;


SELECT  t.cinemaid,
        s.theaterid,
        s.movietitle AS movie_name,
        s.price,
        c.customer_name,
        r.seatid,
        r.dateid
FROM cinema t
JOIN theater s ON t.cinemaid = s.cinemaid
JOIN reservation r ON s.cinemaid = r.cinemaid 
                  AND s.theaterid = r.theaterid
JOIN customer c ON r.customerid = c.customerid
ORDER BY r.dateid, t.cinemaid;

-- 문제3)
------------------------------------------------
-- 1)
SELECT cinemaid FROM theater WHERE price >=9000;
-- 2)
SELECT * FROM cinema, theater WHERE cinema.cinemaid = theater.cinemaid;
-- 3)
SELECT DISTINCT t.cinema_name FROM cinema t JOIN theater s ON t.cinemaid = s.cinemaid WHERE s.price >= 10000;
-- 4)
SELECT c.customerid, c.customer_name, c.customer_address, r.cinemaid, r.theaterid, r.seatid, r.dateid 
FROM customer c LEFT OUTER JOIN reservation r ON c.customerid = r.customerid AND r.dateid > TO_DATE('2024-01-01', 'YYYY-MM-DD');
-- 5)
SELECT DISTINCT c.customer_name FROM customer c WHERE NOT EXISTS (SELECT t.cinemaid FROM cinema t WHERE t.cinema_location = '강남' MINUS SELECT r.cinemaid FROM reservation r WHERE r.customerid = c.customerid);

-- 문제4)
----------------------------------------------------
-- 1)
SELECT cinema_name, cinema_location FROM cinema;
-- 2)
SELECT movietitle FROM theater WHERE price <= 10000;
-- 3)
SELECT customer_name, customer_address FROM customer;
-- 4)
SELECT s.movietitle FROM cinema t JOIN theater s ON t.cinemaid = s.cinemaid WHERE t.cinema_location = '강남';
-- 5)
SELECT c.customer_name FROM customer c WHERE NOT EXISTS (SELECT t.cinemaid FROM cinema t WHERE t.cinema_location = '강남' MINUS SELECT r.cinemaid FROM reservation r WHERE r.customerid = c.customerid);