--계정 생성
CREATE USER user_yhb IDENTIFIED BY java1234;

--권한 부여
GRANT connect, resource, dba to user_yhb;	

----------------------------------------------------------------------------------------------------

--CREATE
DROP TABLE MEMBER;
CREATE TABLE member(
	id varchar2(30) PRIMARY KEY,
	pass varchar2(100),
	name varchar2(50),
	gender char(3),
	tel varchar2(13),
	regdate DATE DEFAULT sysdate
);

DROP TABLE schedule_movie;
CREATE TABLE schedule_movie(
	movie_code char(15) PRIMARY KEY,
	mv_title varchar2(100),
	mv_story varchar2(400),
	mv_runtime NUMBER,
	mv_regdate DATE DEFAULT sysdate
);

DROP TABLE reservation;
CREATE TABLE reservation(
	res_num NUMBER PRIMARY KEY,
	id varchar2(30) REFERENCES MEMBER(id),
	movie_code char(15) REFERENCES schedule_movie(movie_code),
	regdate DATE DEFAULT sysdate
);

DROP TABLE director;
CREATE TABLE director(
	dr_code char(15) PRIMARY KEY,
	dr_name varchar2(50),
	dr_regdate DATE DEFAULT sysdate,
	movie_code char(15) REFERENCES schedule_movie(movie_code)
);

----------------------------------------------------------------------------------------------------

--INSERT
--member
INSERT INTO MEMBER(id, pass, name, gender, tel, regdate) VALUES('son', 1234, '손재옥', '남', '010-7361-9876', default);
INSERT INTO MEMBER(id, pass, name, gender, tel, regdate) VALUES('kim', 1234, '김영주', '남', '010-6712-7652', default);
INSERT INTO MEMBER(id, pass, name, gender, tel, regdate) VALUES('jung', 1234, '정현석', '남', '010-7731-1471', default);

SELECT * FROM MEMBER;

--movie
DROP SEQUENCE seqmovie_code;
CREATE SEQUENCE seqmovie_code;
INSERT INTO schedule_movie(movie_code, mv_title, mv_story, mv_runtime, mv_regdate) 
VALUES (('MV_00000000000' || seqmovie_code.NextVal), '007 노 타임 투 다이(No time to Die)', '가장 강력한 운명의 적과 마주하게된 제임스 본드의 마지막 미션이 시작된다.', 163, default);
INSERT INTO schedule_movie(movie_code, mv_title, mv_story, mv_runtime, mv_regdate) 
VALUES (('MV_00000000000' || seqmovie_code.NextVal), '보이스(On the Line)', '단 한 통의 전화!걸려오는 순간 걸려들었다!', 109, default);
INSERT INTO schedule_movie(movie_code, mv_title, mv_story, mv_runtime, mv_regdate) 
VALUES (('MV_00000000000' || seqmovie_code.NextVal), '수색자(The Recon', '억울하게 죽은 영혼들의 무덤 DMZ', 111, default);
INSERT INTO schedule_movie(movie_code, mv_title, mv_story, mv_runtime, mv_regdate) 
VALUES (('MV_00000000000' || seqmovie_code.NextVal), '기적(Mircle)', '오갈 수 있는 길은 기찻길밖에 없지만 정작 기차역은 없는 마을.', 117, default);

SELECT * FROM schedule_movie;

--director
DROP SEQUENCE seqdr_code;
CREATE SEQUENCE seqdr_code;
INSERT INTO director(dr_code, dr_name, dr_regdate, movie_code) VALUES (('DR_00000000000' || seqdr_code.NextVal), '캐리 후쿠나가', default, 'MV_000000000001');
INSERT INTO director(dr_code, dr_name, dr_regdate, movie_code) VALUES (('DR_00000000000' || seqdr_code.NextVal), '김선', default, 'MV_000000000002');
INSERT INTO director(dr_code, dr_name, dr_regdate, movie_code) VALUES (('DR_00000000000' || seqdr_code.NextVal), '김곡', default, 'MV_000000000002');
INSERT INTO director(dr_code, dr_name, dr_regdate, movie_code) VALUES (('DR_00000000000' || seqdr_code.NextVal), '김민섭', default, 'MV_000000000003');
INSERT INTO director(dr_code, dr_name, dr_regdate, movie_code) VALUES (('DR_00000000000' || seqdr_code.NextVal), '이창훈', default, 'MV_000000000004');

SELECT * FROM director;

--reservation
DROP SEQUENCE seqres_num;
CREATE SEQUENCE seqres_num;
INSERT INTO reservation(res_num, id, movie_code, regdate) VALUES(seqres_num.NextVal, 'son', 'MV_000000000002', default);	--“손재옥” 회원이 “보이스”를 예약한다.
INSERT INTO reservation(res_num, id, movie_code, regdate) VALUES(seqres_num.NextVal, 'son', 'MV_000000000003', default);	--“손재옥” 회원이 “수색자”를 예약한다.
INSERT INTO reservation(res_num, id, movie_code, regdate) VALUES(seqres_num.NextVal, 'kim', 'MV_000000000001', default);	--“김영주” 회원이 “007”을 예약한다.
INSERT INTO reservation(res_num, id, movie_code, regdate) VALUES(seqres_num.NextVal, 'jung', 'MV_000000000002', default);	--“정헌석” 회원이 “보이스”를 예약한다.

SELECT * FROM reservation;

----------------------------------------------------------------------------------------------------

--SELECT
--모든 회원 정보를 검색한다.
SELECT * FROM MEMBER;

--모든 예매 정보를 조회한다.
SELECT * FROM reservation;

--모든 감독 정보를 조회한다.
SELECT * FROM director;

--영화제목, 스토리, 러닝타임, 감독명을 조회한다. (감독이 n명이면 영화가 n건 조회)
SELECT 
	sm.mv_title AS "영화제목",
	sm.mv_story AS "스토리",
	sm.mv_runtime AS "러닝타임",
	d.dr_name AS "감독명"
FROM schedule_movie sm
INNER JOIN director d ON sm.movie_code = d.movie_code;

--보이스 라는 영화의 예약자명, 성별, 전화번호, 예매번호, 예매일을 조회한다. 
--단, 예매일이 마지막에 예매된 순서대로 조회하세요.
SELECT
	m.name AS "예약자명",
	m.gender AS "성별",
	m.tel AS "전화번호",
	r.res_num AS "예매번호", 
	r.regdate AS "예매일"
FROM reservation r
INNER JOIN MEMBER m ON m.id = r.id
INNER JOIN schedule_movie sm ON sm.movie_code = r.movie_code
	INNER JOIN director d ON sm.movie_code = d.movie_code
WHERE sm.movie_code = 'MV_000000000002'
ORDER BY r.regdate DESC;

--백업파일 생성하는 방법 > cmd : 원하는 디렉토리로 이동 > 명령어 실행 > .dmp파일 생성
EXP user_yhb/java1234@xe FILE=backup_yhb_5498.dmp;
