/* Write your T-SQL query statement below 
# Write your MySQL query statement below
# Write an SQL query to rank the scores. The ranking should be calculated according to the following rules:

# The scores should be ranked from the highest to the lowest.
# If there is a tie between two scores, both should have the same  ranking.
# After a tie, the next ranking number should be the next consecutive # integer value. In other words, there should be no holes between ranks.
# Return the result table ordered by score in descending order.
*/

SELECT Score as score, DENSE_RANK() OVER (ORDER BY Score DESC) as Rank
FROM Scores



/* Write your T-SQL query statement below 
Write an SQL query to find employees who have the highest salary in each of the departments.

Return the result table in any order.
*/

WITH CTE as
( SELECT DepartmentId, Name as Employee, Salary,
    DENSE_RANK() OVER (PARTITION BY DepartmentId 
                      ORDER BY Salary DESC) as DenseRank
 FROM Employee
)
SELECT Dep.Name Department, CTE.Employee, CTE.Salary
FROM CTE
JOIN Department Dep
    ON CTE.DepartmentId = Dep.Id
WHERE DenseRank = 1
