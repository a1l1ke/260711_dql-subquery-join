-- 상관 서브쿼리
-- 서브쿼리를 호출한 메인쿼리의 값을 끌어쓰는 것

SELECT
    *
FROM employees e;

-- 특정한 월급 이상의 값
SELECT
    *
FROM employees e
WHERE e.salary > 3000000;

-- 본인 부서 평균보다 높은 사원
SELECT
    *,
    (SELECT d.dept_name
     FROM departments d
     WHERE d.dept_id = e.dept_id)
-- '한 행, 한 열...'
FROM employees e
-- WHERE 안에 있는 서브쿼리는 메인쿼리에서 FROM절까지 처리된 것만 가져올 수 있음
WHERE
    -- e.salary > 3000000
    e.salary > (
        SELECT AVG(e2.salary)
        FROM employees e2
        WHERE e2.dept_id = e.dept_id
    )
;

-- 존재판별 연산자 (EXISTS, NOT EXISTS)
SELECT *
FROM employees e;
-- 프로젝트 배정 이력이 있는가
SELECT *
FROM employee_projects ep;
-- 프로젝트와 직원을 연계시켜줌 (연계테이블)

SELECT *
FROM employees e
WHERE EXISTS (
    SELECT *
    FROM employee_projects ep
    WHERE ep.emp_id = e.emp_id
); -- 열로 가져와서 매칭
-- 1개 이상이면 TRUE, 0개 FALSE

SELECT *
FROM employee_projects ep
WHERE ep.emp_id = 1; -- NULL

SELECT *
FROM employee_projects ep
WHERE ep.emp_id = 2;

-- 열을 표현하는 것마저도 메모리를 씀
SELECT 1
FROM employee_projects ep
WHERE ep.emp_id = 2;

SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.emp_id = e.emp_id
);

SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.emp_id = e.emp_id
);

SELECT *
FROM projects p
WHERE EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.project_id = p.project_id
);