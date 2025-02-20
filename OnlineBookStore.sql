CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--Import CSV file data of Books, Customers and Orders

--Retrive all books in fiction genre

Select * from Books
Where genre='Fiction';

--Find books published after year 1950

Select * from Books
Where published_year>1950;

--list all customers from Canada

Select * from Customers
Where Country like 'Canada';

--Show orders placed in November 2023

Select * from Orders
Where order_date between '01-10-2023' and '20-10-2023';

--Retrive the total stock of books available

Select SUM(Stock) as total_stock from Books;

--Find the details of most expensive book

Select * from Books
Order by Price Desc Limit 1;

--Show all customers who ordered more than 1 quantity of book

Select * from Orders
Where Quantity>1

--Retrive all orders where the total amount exceeds $20

Select * from Orders
Where total_amount>20;

--List all the genre avaialble in Books table

Select distinct genre from books;

--Find the book with the lowest stock

Select * from books
order by stock Asc limit 1;

--Calculate totaal revenue generated from all orders

Select SUM(total_amount) as Revenue from orders;

--Retrive the total number of books sold in each genre

Select B.genre ,SUM(o.quantity)
from orders o
join Books b
ON o.book_id=b.book_id
Group by b.genre;

--Find the average price of books in Fantasy genre

Select Avg(price) as average_price 
from books
Where genre='Fantasy';

--List customers who placed atleast 2 orders

Select customer_id, Count(order_id)
from orders
Group by customer_id
Having Count(order_id)>=2;

--Find most frequently ordered book

Select book_id, Count(order_id) as total_order
from orders
group by book_id
order by total_order desc;

--Show top 3 most expensive books of Fantasy genre

Select * from books
Where genre='Fantasy'
order by price desc limit 3;

--Retrive the total quantity of books sold by each auther

Select b.author,SUM(o.quantity)
from books b
join orders o
on b.book_id=o.book_id
Group by author;

--List the cities where customers who spent over $30 are located

Select distinct c.city,o.total_amount
from orders o
Join customers c
on c.customer_id=o.customer_id
where o.total_amount>30;

--find the customer who spent most on orders 

Select c.customer_id,c.name,sum(o.total_amount) as total_spent_amount
from orders o
join customers c
on c.customer_id=o.customer_id
group by c.customer_id,c.name
order by total_spent_amount desc;

--Calculate the stock remaining after fulfilling all orders

Select b.book_id,b.title, b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o
On b.book_id=o.book_id
group by b.book_id
order by b.book_id desc;
