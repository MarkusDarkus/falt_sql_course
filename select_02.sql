-- Задание 1 (сумма продаж в США в 1 квартале 2012 года)
-- Способ 1: Джойны
SELECT SUM(si.UnitPrice * si.Quantity) AS Sales
FROM sales as s
JOIN sales_items as si 
using(SalesId)
WHERE s.ShipCountry = 'USA' 
  AND s.SalesDate BETWEEN '2012-01-01' AND '2012-03-31';

-- Способ 2: Подзапрос
SELECT SUM(ItemSales.Total) AS TotalSales
FROM (
    SELECT si.UnitPrice * si.Quantity AS Total
    FROM sales s
	  JOIN sales_items as si 
    using(SalesId)
    WHERE s.ShipCountry = 'USA' 
      AND s.SalesDate BETWEEN '2012-01-01' AND '2012-03-31'
) AS ItemSales;


-- Задание 2 (имена клиентов, которых нет среди сотрудников)
-- Способ 1: Подзапрос
SELECT FirstName, LastName
FROM customers
WHERE FirstName NOT IN (SELECT FirstName FROM employees);

-- Способ 2: Джойны
SELECT c.FirstName, c.LastName
FROM customers as c
LEFT JOIN employees as e 
using(FirstName)
WHERE e.FirstName IS NULL;

-- Способ 3: Логическое вычитание
SELECT FirstName, LastName
FROM customers
EXCEPT
SELECT FirstName, LastName
FROM employees;


-- Задание 3 (Теоритическое)
-- Теоретический вопрос. Вернут ли данные запросы одинаковый результат? Да или НЕТ. Объяснить почему. Какой запрос вернет больше строк?
-- Нет, тк в одном случае происходит джойн и затем идет фильтрация строк. 
-- В другом, происходит джойн по ключу
-- Второй список будет шире тк в первом запросе - записи из t1, где column1 != 0, будут исключены после фильтрации


-- Задание 4 
-- Способ 1: Подзапрос
SELECT Title AS AlbumTitle, 
       (SELECT COUNT(*) FROM tracks t WHERE t.AlbumId = a.AlbumId) AS TrackCount
FROM albums a;

-- Способ 2: Джойны
SELECT a.Title AS AlbumTitle, COUNT(t.TrackId) AS TrackCount
FROM albums as a
JOIN tracks as t
using(AlbumId)
GROUP BY a.Title;

-- Задание 5
SELECT DISTINCT c.LastName, c.FirstName
FROM customers as c
JOIN sales as s 
using(CustomerId)
WHERE c.Country = 'Germany' 
  AND s.SalesDate BETWEEN '2009-01-01' AND '2009-12-31'
  AND s.ShipCity = 'Berlin';

-- Задание 6
-- Способ 1: Подзапрос
SELECT c.LastName, c.FirstName
FROM customers c
WHERE (SELECT SUM(si.Quantity)
       FROM sales s
       JOIN sales_items si using(SalesId)
       WHERE s.CustomerId = c.CustomerId) > 30;

-- Способ 2: Джойны
SELECT c.LastName, c.FirstName
FROM customers c
JOIN sales s ON c.CustomerId = s.CustomerId
JOIN sales_items si ON s.SalesId = si.SalesId
GROUP BY c.CustomerId
HAVING SUM(si.Quantity) > 30;

-- Задание 7
SELECT g.Name AS Genre, AVG(t.UnitPrice) AS AvgPrice
FROM genres as g
JOIN tracks as t
using(GenreId)
GROUP BY g.Name as Genre;

-- Задание 8
SELECT g.Name AS Genre
FROM genres as g
JOIN tracks as t 
using(GenreId)
GROUP BY g.Name as Genre
HAVING AVG(t.UnitPrice) > 1;
