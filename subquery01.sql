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