--ex24_pseudo.sql
/*
의사 컬럼, Pseudo Column
- 실제 컬럼이 아닌데 컬럼처럼 행동하는 객체

rownum
- 행번호
- 시퀀스 객체 상관 X
- 현재 테이블의 행번호를 가져오는 역할
- 테이블에 저장된 값이 아니라 select실행 시 동적으로 계산되어 만들어진다(****)
- from절이 실행될 때 각 레코드에 rownum을 할당한다.(*************)
- WHERE절이 실행될 대 상황에 따라 rownum이 재계산된다.(********)
    - from 절에서 만들어진 rownum은 where절이 실행될 때 변경될 수 있다.
*/

SELECT 
	name, buseo,		--컬럼(속성) > OUTPUT > 객체(레코드)의 특성에 따라 다른 값을 가진다.
	100,				--상수 > OUTPUT > 모든 레코드가 동일한 값을 가진다.
	substr(name, 2),	--함수 > INPUT + OUTPUT > 객체의 특성에 따라 다른 값을 가진다.
	rownum				--의사 컬럼 > OUTPUT > 
FROM tblinsa;


--게시판 > 페이지
-- 1페이지 > rownum between 1 and 20
-- 2페이지 > rownum between 21 and 40

--O
SELECT name, buseo, rownum FROM tblinsa WHERE rownum = 1;
SELECT name, buseo, rownum FROM tblinsa WHERE rownum <= 5;
--X
SELECT name, buseo, rownum FROM tblinsa WHERE rownum = 5;
SELECT name, buseo, rownum FROM tblinsa WHERE rownum > 5 AND rownum <= 10;

SELECT name, buseo, rownum 			--2. 소비 > 1에서 만든 rownum을 가져온다.(여기서 생성은 ㄴㄴ)
FROM tblinsa;						--1. 생성 > FROM절이 실행되는 순간 모든 레코드에 rownum 할당

SELECT name, buseo, rownum 			--3. 소비
FROM tblinsa						--1. 생성
WHERE rownum = 1;					--2. 조건

SELECT name, buseo, rownum 			--3. 소비
FROM tblinsa						--1. 생성
WHERE rownum = 3;					--2. 조건

--내가 원하는 순서대로 정렬 후 > rownum을 할당하는 방법 > 서브쿼리 사용(***)
SELECT name, buseo, basicpay, rownum, rnum
FROM 
	(SELECT name, buseo, basicpay, rownum AS rnum 
	FROM tblinsa
	ORDER BY basicpay DESC)
WHERE rownum <= 3;

-- 급여 5~10등까지
-- 원하는 범위 추출(1 포함X) > rownum 사용 불가능
-- 1. 내가 원하는 순서대로 정렬
-- 2. 1을 서브쿼리로 묶는다. + rownum(rnum)
-- 3. 2를 서브쿼리로 묶는다. + rownum(불필요) + rnum(사용***)
SELECT name, buseo, basicpay, rnum, rownum						
		FROM (SELECT name, buseo, basicpay, rownum AS rnum		--2
	    FROM (SELECT name, buseo, basicpay
		FROM tblinsa
		ORDER BY basicpay DESC))								--1
WHERE rnum BETWEEN 5 AND 10;

--페이징 > 나눠서 보기 > 한번에 20명씩, 정렬 이름순
SELECT * FROM tbladdressbook;			--2000

--1
SELECT * FROM tbladdressbook ORDER BY name ASC;
--2 이때의 rownum이 필요하다.
SELECT a.*, rownum FROM (SELECT * FROM tbladdressbook ORDER BY name ASC) a;
--3. rownum을 조건으로 사용 > 한번 더 서브쿼리
SELECT * FROM(SELECT a.*, rownum FROM (SELECT * FROM tbladdressbook ORDER BY name ASC) a);
--4 
SELECT * FROM(SELECT a.*, rownum AS rnum FROM (SELECT * FROM tbladdressbook ORDER BY name ASC) a) WHERE rnum BETWEEN 1 AND 20;
SELECT * FROM(SELECT a.*, rownum AS rnum FROM (SELECT * FROM tbladdressbook ORDER BY name ASC) a) WHERE rnum BETWEEN 21 AND 40;
SELECT * FROM(SELECT a.*, rownum AS rnum FROM (SELECT * FROM tbladdressbook ORDER BY name ASC) a) WHERE rnum BETWEEN 1981 AND 2000;

CREATE OR REPLACE VIEW vwAddressBook
AS
SELECT a.*, rownum AS rnum FROM (SELECT * FROM tbladdressbook ORDER BY name ASC) a;

SELECT * FROM vwaddressbook;
SELECT * FROM vwaddressbook WHERE rnum BETWEEN 1 AND 20;





