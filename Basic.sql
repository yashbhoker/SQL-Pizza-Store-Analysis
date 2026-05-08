/* first question querry */
select count(order_id) As total_orders
from orders;

/* second question querry */
select count(quantity) as total_quantity
from order_details;

/* third question querry */
select pizza_types.name, pizzas.size, pizzas.price
from pizzas
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id;

/* fourth question querry */
select distinct category
from pizza_types;

/* fifth question querry */
select pizza_types.name , pizzas.price
from pizzas
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by price desc
limit 1;

/* sixth question */
select orders.date, count(distinct orders.order_id) as total_orders
from orders
join order_details
on orders.order_id = order_details.order_id
group by orders.date
order by orders.date;

/* seventh question */
select pizzas.pizza_type_id, count(order_details.order_id) as total_orders
from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.pizza_type_id
order by total_orders desc
limit 1;

/* eighth question */
select pizzas.size, sum(order_details.quantity) as total_quantity_sold
from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size
order by pizzas.size;

/* ninth question */
select pizzas.pizza_type_id, count(order_details.order_id) as total_orders
from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.pizza_type_id
order by total_orders desc
limit 5;

/* tenth question */
select pizza_types.category , count(distinct pizza_types.pizza_type_id) as category_available
from pizza_types
group by category;
