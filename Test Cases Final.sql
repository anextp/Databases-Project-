-- Testing the trigger on orderdetails which assists in 
-- calculating and updating the total price paid for a certain order after each new insertion 
select order_id, total_price
from orders_online;


-- Testing the trigger keeping track of possible resellers 
SELECT * 
FROM possible_resellers;

-- Testing the Ages function on employees 

-- case 1 : the employee's birthday has happened already 
select e.*, employee_age(e.employee_id)
from employees e
where e.employee_id = 'REID001';

-- case 2 : the employee's birthday has not happened yet 
select e.*, employee_age(e.employee_id)
from employees e
where e.employee_id = 'REID002';

