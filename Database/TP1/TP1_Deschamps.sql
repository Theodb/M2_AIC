--Q3
SELECT city, country, count(firstname) nb_emp
from employees
group by city, country
HAVING count(firstname)>0
order by nb_emp DESC;
--Q4
SELECT count(city) nb_villes, count (distinct country) nb_pays 
from(
SELECT city, country, count(firstname) nb_emp
from employees
group by city, country
HAVING count(firstname)>0
) as citylist; 
--Q5
SELECT company_name, pr.product_name
FROM products pr
INNER JOIN suppliers sup ON pr.supplier_id=sup.supplier_id
WHERE pr.product_name='Chartreuse verte';
--Q6
SELECT company_name, cat.category_name
FROM products pr
INNER JOIN suppliers sup ON pr.supplier_id=sup.supplier_id
INNER JOIN categories cat ON pr.category_id=cat.category_id
WHERE pr.product_name IS NOT NULL
ORDER BY cat.category_name DESC, sup.company_name;
--Q7
SELECT max(unit_price) from products;
--Q8
SELECT product_name, max(unit_price) maxprice
FROM products
GROUP BY product_name
ORDER BY maxprice DESC
limit 5;
--Q9
SELECT 
FROM suppliers sup
INNER JOIN categories cat on cat.supplier_id=sup.supplier_id
WHERE cat.category_name='Seafood' OR cat.category_name='Beverages'
