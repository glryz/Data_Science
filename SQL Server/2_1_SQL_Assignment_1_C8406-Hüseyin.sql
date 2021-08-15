-- a.    Create table and insert values

	-- Create Table

CREATE TABLE transactions (
    Sender INT NOT NULL,
	Receiver INT NOT NULL,
	Amount INT NOT NULL,
    Transaction_date VARCHAR (25) NOT NULL,
	);

	-- Insert Values

INSERT INTO transactions (Sender,Receiver,Amount,Transaction_date)

VALUES

(5,2,10,'2-12-20'),
(1,3,15,'2-13-20'),
(2,1,20,'2-13-20'),
(2,3,25,'2-14-20'),
(3,1,20,'2-15-20'),
(3,2,15,'2-15-20'),
(1,4,5,'2-16-20')

SELECT *
FROM transactions


-- b. Sum amounts for each sender (debits) and receiver (credits)

	-- Sum amounts for each sender (debits) 

SELECT sender, SUM(amount) AS debits
FROM transactions
GROUP BY sender

	-- Sum amounts for each receiver (credits) --

SELECT receiver, SUM(amount) AS credits
FROM transactions
GROUP BY receiver


SELECT sender, SUM(amount) AS debited
INTO debits
FROM transactions
GROUP BY sender

select *
from debits

SELECT receiver, SUM(amount) AS credited
INTO credits
FROM transactions
GROUP BY receiver

select *
from credits

--c. Full (outer) join debits and credits tables on user id, taking net change as the difference between credits and debits, coercing nulls to zeros with coalesce()

SELECT coalesce(sender, receiver) AS "User", 
coalesce(credited, 0) - coalesce(debited, 0) AS Net_Change 
FROM debits D
FULL JOIN credits C
ON D.sender = C.receiver
ORDER BY 2 DESC
