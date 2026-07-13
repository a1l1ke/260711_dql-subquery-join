-- 1. 부서 테이블 (부모 테이블)
CREATE TABLE IF NOT EXISTS departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
    );

-- 2. 사원 테이블 (자식 테이블, SELF 참조 포함)
CREATE TABLE IF NOT EXISTS employees (
                                         emp_id INT AUTO_INCREMENT PRIMARY KEY,
                                         emp_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    salary DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    manager_id INT DEFAULT NULL,
    dept_id INT DEFAULT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id) ON DELETE SET NULL
    );

-- 3. 프로젝트 테이블
CREATE TABLE IF NOT EXISTS projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2) NOT NULL
    );

-- 4. 사원-프로젝트 관계 테이블 (N:M 관계 해소를 위한 매핑 테이블)
CREATE TABLE IF NOT EXISTS employee_projects (
     emp_id INT,
     project_id INT,
     assigned_date DATE NOT NULL,
     PRIMARY KEY (emp_id, project_id),
     FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
     FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
    );

-- 데이터 초기화 및 재적재 (기존 데이터 중복 방지)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE employee_projects;
TRUNCATE TABLE projects;
TRUNCATE TABLE employees;
TRUNCATE TABLE departments;
SET FOREIGN_KEY_CHECKS = 1;

-- 부서 데이터 삽입
INSERT INTO departments (dept_id, dept_name, location) VALUES
   (10, '인사팀', '서울'),
   (20, '개발팀', '판교'),
   (30, '기획팀', '부산'),
   (40, '마케팅팀', '서울'),
   (50, '임시대기부서', '대전'); -- 사원이 없는 빈 부서

-- 사원 데이터 삽입
INSERT INTO employees (emp_id, emp_name, role, salary, manager_id, dept_id) VALUES
    (1, '김대표', 'CEO', 15000000.00, NULL, 10),
    (2, '박팀장', 'Developer Leader', 8000000.00, 1, 20),
    (3, '이팀장', 'Planning Leader', 7000000.00, 1, 30),
    (4, '최개발', 'Senior Developer', 6000000.00, 2, 20),
    (5, '정개발', 'Junior Developer', 4000000.00, 2, 20),
    (6, '강기획', 'Planner', 4500000.00, 3, 30),
    (7, '윤인사', 'HR Specialist', 4200000.00, 1, 10),
    (8, '홍길동', 'Intern', 2500000.00, NULL, NULL); -- 소속 부서가 없는 사원

-- 프로젝트 데이터 삽입
INSERT INTO projects (project_id, project_name, budget) VALUES
    (101, '차세대 ERP 시스템 구축', 500000000.00),
    (102, '모바일 앱 서비스 개발', 200000000.00),
    (103, '글로벌 마케팅 캠페인', 100000000.00),
    (104, '신규 기획 타당성 검토', 50000000.00);

-- 사원-프로젝트 참여 데이터 삽입
INSERT INTO employee_projects (emp_id, project_id, assigned_date) VALUES
  (2, 101, '2026-01-10'),
  (4, 101, '2026-01-15'),
  (5, 101, '2026-02-01'),
  (2, 102, '2026-03-01'),
  (5, 102, '2026-03-10'),
  (3, 104, '2026-04-01'),
  (6, 104, '2026-04-05');

-- 1. 스칼라 서브쿼리
-- 한 행과 한 열로 반환 -> 컬럼 값 대용으로
SELECT
    *
FROM employees e;

SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id
FROM employees e;

SELECT
    *
FROM
    departments d;

SELECT
    d.dept_id,
    d.dept_name
FROM
    departments d;

-- 1) 호출 순서 상 FROM 절을 넘어가면 테이블상의 컬럼을 호출 가능
-- 2) SELECT 내부의 컬럼을 호출할 때 그 내부에 SELECT를 호출하면,
-- 외부의 SELECT에서 이미 사용중인 값을 고스란히 사용할 수 있음
-- 3) 스칼라 서브쿼리 -> 한 행, 한 열로 한정시키면 SELECT에서 값으로 사용할 수 있다
SELECT
    e.emp_id, -- 한 행마다 고정되어 있는 값 (emp, dept나 둘 다 1개로 고정)
    e.emp_name,
    e.dept_id,
    (SELECT
         d.dept_name
     FROM
         departments d
     WHERE
         e.dept_id = d.dept_id -- 고정되어있는 값을 통해서 한행/한열 이라는 제약.
    ) AS dept_name
FROM employees e;

SELECT
    d.dept_name
FROM
    departments d
WHERE
    20 = d.dept_id;

SELECT
    e.emp_id, -- 한 행마다 고정되어 있는 값 (emp, dept나 둘 다 1개로 고정)
    e.emp_name,
    e.dept_id,
    (SELECT
         d.dept_name
     FROM
         departments d
     WHERE
         10 = d.dept_id -- 고정되어있는 값을 통해서 한행/한열 이라는 제약.
    ) AS dept_name
FROM employees e;
-- e.dept_id가 고정값으로 들어가면 2개 이상 데이터로 인해 스칼라 X
-- d.dept_id면 1개의 데이터이긴한데 스칼라를 쓰는 이유가 X.

-- 2. 비상관 서브쿼리
-- 메인 쿼리 (외부 쿼리, 상위 쿼리...) 의 데이터를 공유하지 않고, 단독 수행되어서 '상수'

-- 2-1. WHERE 절
SELECT AVG(salary) FROM employees;

SELECT
    *
FROM employees
WHERE salary >
      (SELECT AVG(salary) FROM employees);
-- 서브쿼리는 괄호 필수 (먼저 실행 유도)

SELECT salary FROM employees WHERE dept_id = 20;
-- 3명, 8M / 6M / 4M

SELECT
    *
FROM employees
WHERE salary >
          ANY (SELECT salary FROM employees WHERE dept_id = 20);
-- 비상관 서브쿼리로 만들어진 데이터 중에 1개로도 조건을 만족시키면...
-- 20(개발) -> 개발팀의 급여 중에 가장 최저값보다 높은사람.

-- 집계(그룹)함수 활용하고 싶을 경우...

-- 2-2. FROM. 인라인뷰
SELECT
    dept_id,
    AVG(salary)
FROM employees
GROUP BY dept_id;

SELECT
    *
FROM
    (SELECT
         dept_id,
         AVG(salary) AS avg_salary
     FROM employees
     GROUP BY dept_id)
        AS temp
WHERE avg_salary >= 5000000;
-- SELECT까지 마쳐서 alias까지 된 값을 깔끔하게 불러올 수 있다

-- 2-3. HAVING
SELECT
    dept_id,
    AVG(salary)
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);
-- HAVING에서 전체 테이블 관련 집계함수를 쓰거나 다른 테이블의 값을 써주고 싶을 때
-- HAVING 절 차에서 서브쿼리를 넣어줄 수 있다