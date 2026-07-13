-- 실행 순서 (SELECT)

-- 1단계 : FROM
SELECT
    *
FROM
    products;
-- ON, USING (JOIN)

-- 2단계 : WHERE
SELECT
    *
FROM
    products
WHERE
    price >= 50000;

-- 3단계 : GROUP BY
SELECT
    -- * -- GROUP BY 사용 시 GROUP BY의 기준이 되는 column 혹은 그룹(집계)함수만 사용 가능
    category
FROM
    products
WHERE
    price >= 50000
GROUP BY
    category;

SELECT
    category
FROM
    products
GROUP BY
    category;

-- 4단계 - HAVING
SELECT
    category,
    AVG(price)
FROM
    products
WHERE
    price >= 50000
GROUP BY
    category;

SELECT
    category,
    AVG(price)
FROM
    products
WHERE
    price >= 50000
-- 이미 여기서 걸러내졌기 때문에
GROUP BY
    category
HAVING
    AVG(price) > 200000;

SELECT
    category,
    AVG(price)
FROM
    products
GROUP BY
    category
HAVING
    AVG(price) > 20000;

-- 5단계 : SELECT 컬럼절
SELECT
    category,
    AVG(price),
    COUNT(*), -- FROM절에서 호출된 테이블이, WHERE/GROUP BY/HAVING 등을 거쳐서
    -- 1. 필터링된 row 2. FROM/JOIN 등을 통해 결정된 column 3. group 여부를 통해 결정한 그룹(집계)함수까지
    GROUP_CONCAT(product_name) -- ',' <- 구분자를 지정할 수 있음
-- GROUP_CONCAT(product_name, ';')
FROM
    products
WHERE
    price >= 50000
GROUP BY
    category
HAVING
    AVG(price) > 100000;

-- 6단계 : ORDER BY
SELECT
    category,
    AVG(price) AS '평균가',
    COUNT(*) AS '갯수',
    GROUP_CONCAT(product_name)
-- 1. FROM, 2. GROUP BY, 3. SELECT - Alias
FROM
    products
WHERE
    price >= 30000
GROUP BY
    category
HAVING
    AVG(price) > 10000
-- ORDER BY AVG(price)
-- ORDER BY "평균가"; -- ALIAS를 준 이름의 경우에는 ""로 해야 인식(mysql)
ORDER BY category;
-- ORDER BY price; -- GROUP BY 상태라면 ORDER BY 시
-- 1) GROUP BY에 포함된 컬럼 2) 집계함수만 사용 가능

-- 7단계 : LIMIT (MySQL)
SELECT
    category,
    AVG(price) AS '평균가',
    COUNT(*) AS '갯수',
    GROUP_CONCAT(product_name)
FROM
    products
WHERE
    price >= 30000
GROUP BY
    category
HAVING
    AVG(price) > 10000
ORDER BY category
    LIMIT 1;

-- GROUP BY (2개 이상)
SELECT
    *
FROM sales_records;

SELECT
    sale_date, product_id,
    SUM(unit_price), AVG(unit_price)
FROM sales_records
GROUP BY
    sale_date, product_id;