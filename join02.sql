-- 다중 조인

SELECT * FROM employees;
SELECT * FROM products;
SELECT * FROM employee_projects;
-- 1:1, 1:N, N:M
-- 1:N - 중개테이블 - N:1
SELECT
    *
FROM employees e
-- JOIN employee_projects ep
         LEFT JOIN employee_projects ep
                   ON e.emp_id = ep.emp_id
-- LEFT JOIN projects p
         INNER JOIN projects p
-- 가장 마지막에 나온 INNER JOIN을 기준으로 앞에 ON/USING이 NULL이었던 것 사라짐
                    ON ep.project_id = p.project_id;

-- 조인 사용 그룹핑
SELECT
    emp_name,
    count(p.project_name) AS "프로젝트숫자"
FROM employees e
         LEFT JOIN employee_projects ep
                   ON e.emp_id = ep.emp_id
         LEFT JOIN projects p
                   ON ep.project_id = p.project_id
GROUP BY e.emp_name;

-- 조인 사용 필터링 (FROM 비상관 서브쿼리 - 인라인 뷰)
SELECT
    *
FROM employees e
         INNER JOIN departments d
                    ON e.dept_id = d.dept_id;

SELECT
    *
FROM employees e
         INNER JOIN departments d
                    ON e.dept_id = d.dept_id
WHERE d.location = '판교';

SELECT
    *
FROM employees e
         INNER JOIN departments d
                    ON e.dept_id = d.dept_id AND d.location = '판교';
-- 뒤에 더 많은 JOIN이 있거나 UNION 등으로 합쳐진 다음에 조건절을 하는 경우...
-- 다중 조건의 경우 (5~10개까지도 함)
-- 필드, 컬럼, 속성을 건들일이 없을 때

SELECT
    *
FROM employees e
         INNER JOIN (
    -- departments d
    SELECT
        -- *
        dept_id
    FROM
        departments
    WHERE
        location = '판교'
) d
                    ON e.dept_id = d.dept_id;
-- 컬럼의 수, 집계함수의 결과 등을 사용하기 위해서 어차피 인라인 뷰를 쓴다면
-- 이 안에서 미리 줄여서 ON까지 넘어가는 갯수를 줄이기도 한다

-- 크로스 조인
-- 조인 조건이 없이 가능한 조합을 만드려는 조인
SELECT
    e.emp_name, p.project_name
-- FROM employees e, projects p
FROM employees e
-- JOIN projects p; -- 이렇게 해놓으면 왜 ON, USING 없냐고 시비검
         CROSS JOIN projects p;

-- 셀프 조인
-- SELF JOIN
-- 댓글 -> 대댓글
-- 추천인 / 팔로우 M:N
SELECT
    -- emp_id, emp_name, manager_id
    e.emp_id AS '부하직원ID',
    e.emp_name AS '부하직원이름',
    e2.emp_id AS '관리자ID',
    e2.emp_name AS '관리자이름'
FROM
    employees e
        JOIN
    employees e2
    ON
        e.manager_id = e2.emp_id;
