SELECT
    *
FROM employees e;

SELECT
    *
FROM
    employees e, departments d
WHERE -- FROM을 마치고 나서 다음에 오는 위치
      e.dept_id = d.dept_id;
-- ANSI 표준 방법

SELECT
    *
FROM
    employees e
        -- JOIN departments d -- ,가 아니라 명시적으로 어느 순서로 테이블들이 결합하는지를 알려주는 키워드 JOIN
        INNER JOIN departments d -- ,가 아니라 명시적으로 어느 순서로 테이블들이 결합하는지를 알려주는 키워드 JOIN
    -- 특정 JOIN을 할 때 우선적으로 실행된 WHERE문.
                   ON e.dept_id = d.dept_id
                       AND salary > 5000000; -- record를 애초에 제외해서 성능향상. / 서브쿼리로 줄여
-- WHERE -> 필러팅 -> 메모리 상에 유지시키는 row의 범위.

SELECT
    *
FROM
    employees e
        INNER JOIN departments d
        -- ON e.dept_id = d.dept_id; -- 합치려는 컬럼명이 같을 때
                   USING (dept_id);
-- 각각의 테이블에 존재를 무시하고, 합친 해당 컬럼을 만듦
-- id, dept_id, d_id ...

-- WHERE, ON, USING -> 조인의 조건절로 기능할 수 있음
-- WHERE : 테이블을 합치기 위한 조건과 실제 레코드들을 필터링하기 위한 조건이 혼합됨
-- 실행 순서가 꼬이면서 성능 저하가 일어날 수 있음
-- ON : WHERE절과 완전 유사하나 JOIN 다음에만 올 수 있음
-- 중복되는 이름들을 딱히 건들지 않음
-- USING : 컬럼들의 조합(dept_id -> emp_id, dept_id...)
-- 1개 모음 / 일치 외의 다른 조건에 대한 연산자 등을 지원하지 X (=)
-- MySQL에서 보게 되는 'JOIN'은 inner join이다. (두 개의 테이블 중 조건을 모두 만족시키는 행만 남기는 것)


-- [Outer JOIN]
-- INNER JOIN
SELECT
    *
FROM
    employees e -- 왼쪽 테이블에
        INNER JOIN departments d
        -- 오른쪽 테이블을 합치는데
                   ON e.dept_id = d.dept_id;
-- ON/USING절에 있는 조건을 만족시키는 왼.오 데이터만 남긴다

SELECT
    *
FROM
    employees e -- 왼쪽 테이블의 데이터는 일단 남기고
    -- LEFT OUTER JOIN departments d
        LEFT JOIN departments d
                  ON e.dept_id = d.dept_id;
-- 조건을 만족하는 오른쪽 데이터만 남긴다

SELECT
    *
FROM
    employees e
        -- RIGHT OUTER JOIN departments d
        RIGHT JOIN departments d -- 오른쪽 테이블의 데이터는 일단 남기고
                   ON e.dept_id = d.dept_id;
-- 조건을 만족하는 왼쪽 데이터만 남긴다

SELECT
    *
FROM
    employees e
        LEFT JOIN departments d
                  ON e.dept_id = d.dept_id
UNION -- 좌우가 아니라 위아래로 합친다
-- DISTINCT 옵션이 숨어 있다 (일치하는 record를 DISTINCT처럼)
-- UNION ALL -- 중복을 허용하되 성능을 보존
SELECT
    *
FROM
    employees e
        RIGHT JOIN departments d
                   ON e.dept_id = d.dept_id;
-- DISTINCT, ORDER BY와 UNION