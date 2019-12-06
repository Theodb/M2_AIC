/* 
Section 1
*/
drop table t;

create table t(
	nom text, 
	age int
);
-- we could also have used varchar(40), for instance, for nom
alter table t add constraint pk_nom PRIMARY KEY(nom);

insert into t values('Marie',10);
insert into t values('Henri',5);
insert into t values('Philippe',5);
insert into t values('Alix',5);
insert into t values('Marie',4);
insert into t values('Foy',14);

/* 
we observe that 2nd insertion of Marie fails. It fails because it violates primary key.
The other insertions do not raise any trouble (they do not violate constraints).
*/
update t set age = age+2 where nom = 'Henri';
update t set age = age+3 where nom = 'Henri';
-- age gets raised by 5 overall. No issue; there are no constraints on age.
update t set nom='Henri' where nom='Foy'
update t set nom=NULL where nom='Foy'
-- both fail because of primary key on nom
delete from t where age >= 6 and age < 11; 
-- no issue

create table sponsor(
	sponsor text, 
	recipient text
);
alter table sponsor add constraint fk_recipient foreign key (recipient) references t(nom);
alter table sponsor add constraint fk_sponsor foreign key (sponsor) references t(nom);

insert into sponsor values('Philippe','Foy');
insert into sponsor values('Alix','Foy');
	
update sponsor set sponsor = 'Alma' where sponsor = 'Alix'
-- fails because violates foreign key fk_parrain.

/* 
Section 2
*/
-- Q1
select firstname, lastname, city
from employees
where country='UK';

-- Q2
select count(*) nb_employes from employees
;

-- Q3
select distinct city from employees
;

-- Q4
select count(distinct city) nb_villes, 
	count(distinct country) nb_pays 
from employees
;

-- Q5
select company_name, product_name
from suppliers s, products p
where s.supplier_id = p.supplier_id
	and product_name = 'Chartreuse verte'
;

-- Q6
select distinct company_name, category_name
from suppliers s, products p, categories c
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
order by category_name desc, company_name
;

-- Q7
select max(unit_price) prix from products
;

-- Q8
select  p1.product_name, p1.unit_price prix
from products p1, 
	(select max(unit_price) maxprice from products) p2
where p1.unit_price = p2.maxprice
;

select product_name, unit_price prix
from products 
order by unit_price desc limit 1
;

-- Q9
select distinct company_name
from suppliers s, products p, categories c
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
	and (category_name = 'Seafood' OR category_name = 'Beverages')
order by company_name
;


-- Q10
select company_name
from suppliers s, products p, categories c
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
	and category_name = 'Seafood'
except
select company_name
from suppliers s, products p, categories c
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
	and category_name = 'Beverages'
order by company_name
;

-- Q11
select company_name
from suppliers s, products p, categories c
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
	and category_name = 'Seafood'
intersect
select company_name
from suppliers s, products p, categories c
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
	and category_name = 'Beverages'
order by company_name
;

select company_name
from suppliers s, products p, categories c, products p2, categories c2
where s.supplier_id = p.supplier_id 
	and s.supplier_id = p2.supplier_id 
	and c.category_id = p.category_id
	and c2.category_id = p2.category_id
	and c.category_name = 'Seafood'
	and c2.category_name = 'Beverages'
order by company_name
;

-- Q12
select company_name, p.unit_price + p2.unit_price amount
from suppliers s, products p, categories c, products p2, categories c2
where s.supplier_id = p.supplier_id 
	and s.supplier_id = p2.supplier_id 
	and c.category_id = p.category_id
	and c2.category_id = p2.category_id
	and c.category_name = 'Seafood'
	and c2.category_name = 'Beverages'
order by company_name
;

-- Q13
select sum(od.unit_price * (1-discount) * quantity) montant
from order_details od
;

-- Q14
select cu.country customer_country, 
s.country supplier_country, 
c.category_name category, 
count(distinct o.order_id) nb_commandes, 
sum(od.unit_price * (1-discount) * quantity) montant
from suppliers s, products p, categories c, order_details od, orders o, customers cu
where s.supplier_id = p.supplier_id 
	and c.category_id = p.category_id
	and p.product_id = od.product_id
	and o.order_id = od.order_id
	and cu.customer_id = o.customer_id
group by cu.country, s.country, c.category_name 
;

-- Q15
select 'fax' fax, count(*) nb from customers where fax is not null
union
select 'no fax' fax, count(*) nb from customers where fax is null
;


select case when fax is not null then 'fax' else 'no fax' end fax, count(*) 
from customers
group by case when fax is not null then 'fax' else 'no fax' end
;

-- Q16
select contact_name 
from customers 
where country='France' and postal_code like '44%' and fax is not null;
;

-- Q17
select lastname, count(*) nb
from employees e, orders o
where e.employee_id=o.employee_id
group by e.employee_id, e.lastname
having count(*) >= 50
order by lastname, nb desc
;

-- Q18
create table orders2 as select * from orders where order_id<10264 
;

-- Q19
select e.lastname, count(distinct order_id) nb
from employees e left outer join orders2 o2
on e.employee_id=o2.employee_id
group by e.employee_id, e.lastname
order by nb desc
;