# Question 1 Swap Salart from LeetCode
# Write your MySQL query statement below: 
# Write an SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) with a single update statement and no intermediate temp table(s).

#Assuming the data is cleaned and there are only 'm' & 'f' in the [sex] columns
UPDATE salary 
SET sex = (CASE WHEN
            sex = 'f' THEN 'm'
            ELSE 'f'
          END);
          
          
          
# Write your MySQL query statement below
# 'Not boring' question
# Write an SQL query to report the movies with an odd-numbered ID and a description that is not "boring".

Return the result table in descending order by rating.
SELECT *
FROM cinema
WHERE id%2 != 0 AND
description <> 'boring'
ORDER BY rating DESC;



# Write your MySQL query statement below
# Questions emploees earning more than manager
# Write an SQL query to find the employees who earn more than their managers.


SELECT Name AS Employee
FROM Employee a
JOIN Employee b
    on a.ManagerID = b.ID
WHERE a.salary > b.salary

# Write your MySQL query statement below
# Remove duplicate emails 

SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(Email) > 1;


# Write your MySQL query statement below
# Write an SQL query to report the first name, last name, city, and state of each person in the Person table. If the address of a PersonId is not present in the Address table, report null instead.

SELECT FirstName, LastName, City, State
FROM Person Pers
LEFT JOIN Address Addr
on Pers.PersonID = Addr.PersonID

