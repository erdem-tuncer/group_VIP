



SELECT [Doctor], [Professor], [Singer], [Actor] 
FROM (SELECT ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) rn, name,occupation 
        FROM OCCUPATIONS
        GROUP BY Occupation, Name) AS tab2 
		pivot 
		(max(name) for Occupation in ([Doctor],[Professor], [Singer], [Actor])) AS Tab1 
        ORDER BY rn



--- other solution

SELECT
    [Doctor], [Professor], [Singer], [Actor]
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) [RowNumber], * FROM OCCUPATIONS
) AS tempTable
PIVOT
(
    MAX(NAME) FOR OCCUPATION IN ([Doctor], [Professor], [Singer], [Actor])
) AS pivotTable

---There is no difference between min OR max, because you have only one name for one occupation for each rownumber min(name) = max(name).
SELECT
    [Doctor], [Professor], [Singer], [Actor]
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) [RowNumber], * FROM OCCUPATIONS
) AS tempTable
PIVOT
(
    min(NAME) FOR OCCUPATION IN ([Doctor], [Professor], [Singer], [Actor])
) AS pivotTable


---If you try to run the query without subquery with window function, you get only one row with min or max function.
SELECT [Doctor], [Professor], [Singer], [Actor]
FROM occupations t
PIVOT
(
	max(name)
	FOR occupation IN ([Doctor], [Professor], [Singer], [Actor]) 
) AS P


select * , row_number() over(partition by occupation order by name) as RN
from occupations


--- https://www.hackerrank.com/challenges/binary-search-tree-1/problem?isFullScreen=true&h_r=next-challenge&h_v=zen

select *
from BST

SELECT COUNT(*) FROM BST AS B WHERE P=B.N

SELECT N, IF(P IS NULL,'Root',IF((SELECT COUNT(*) FROM BST WHERE P=B.N)>0,'Inner','Leaf')) FROM BST AS B ORDER BY N;


--EASIEST
select N, 
	case when P is NULL then 'Root' 
	when N in (select P from BST) then 'Inner' 
	else 'Leaf' 
	end as Node 
from BST 
order by N;



SELECT N,
	CASE WHEN P IS NULL THEN 'Root'
	WHEN N IN (SELECT P FROM BST) THEN 'Inner'
	ELSE 'Leaf'
	END AS NODE
FROM BST
ORDER BY N