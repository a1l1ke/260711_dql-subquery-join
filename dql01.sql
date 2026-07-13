-- 그룹화
SELECT
    *
FROM
    products;
-- category 기준으로 상품 수, 평균 가격을 보고 싶다
SELECT
    category,
    price
FROM
    products;

SELECT
    category
FROM
    products
-- WHERE
GROUP BY
    category;
-- SELECT DISTINCT category ...

SELECT
    category,
    COUNT(*) AS '상품 수',
	-- 집계 함수를 사용하면 각각 그룹별 값을 볼 수 있다
    AVG(price) AS '가격 평균'
FROM
    products
GROUP BY
    category;

SELECT
    category,
    COUNT(*) AS '상품 수',
    AVG(price) AS '가격 평균'
FROM
    products
-- 테이블에서 데이터를 호출할 때 걸러내는 것
-- WHERE
-- 	AVG(price) > 100000
-- SQL Error [1111] [HY000]: Invalid use of group function
-- WHERE 안에서는 그룹함수(집계함수) 사용 X
-- 그렇게 걸러내진 데이터를 특정 컬럼을 기준으로 묶는 것
GROUP BY
    category
-- 그룹이 나뉜 상태에서, 해당 그룹이 그룹(집계)함수를 가지고 만든 값을 가지고 있는지
HAVING AVG(price) > 100000;
