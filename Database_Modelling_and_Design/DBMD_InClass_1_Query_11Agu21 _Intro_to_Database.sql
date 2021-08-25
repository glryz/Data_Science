/*           
--------- DATABASE MODELLING AND DESIGN - SESSION 1 (11.08.2021) -------------

SESSION 1 CONTENTS

-WHAT IS DATA?
-DBMS FUNDAMENTAL CONCEPTS
-DATABASE USERS
-RELATIONAL DATA MODEL CONCEPTS
-ENTITY RELATIONSHIP DIAGRAM
-CARDINALITY AND CONNECTIVITY
-INTEGRITY RULES AND CONSTRAINTS

			--> WHAT IS DATA? <--

Data is everything. If smth has features it can be data for us.
Metadeta means: These are set of data that provide information about other data. For ex: relative, context, dependent data 

			--> DATA BASE MANAGEMENT SYSTEM FUNDAMENTAL CONCEPTS <--

Let's look at first database approach.
Database Approach: Short explanation, databases recently providing, storing and retrieving users data.

So, what is database?
Repository of data. Collection of related data. Ex: banking system, online shopping, social media sites etc.

Database Proerties
Column - Row and Table 

What is DBMS?
Collection of programs that enables users to create-maintain database and control all access. Remember SQL queries.

Most popular Data Base Management Systems?
MySQL, Oracle, SQLite, PostgreSQL, MSSQLServer, MSAccess ...

Characteristics of DBMS?
-Self-describing -> whole how it works, when or how or everything depends the database
-Support multiple views -> remember creating specific views
-Multiuser system
-Data redundancy -> Relational database system has some features to prevent redundancy like normallization
-Integrity constraints -> pk or fk assigning while creating
-Access properties
-Data independence
-Transaction processing -> you can make something that allows delete, create etc
-Backup and recovery facilities

Note: MS Azure and SQL Database Server using cloud system

Components Of DBMS
hardware, software, tools(we can use at R databases), data, procedures and database access language (sql or another)

DBMS Language
It's query, like create, read(select), update, delete

Ad Hoc- Procedural Queries
Ad hoc queries are just for one time work, as we wrote at sql classes
Procedural queries, creating for schema or procedure and these are like tables and long term, we can use them again and again.

Query Process
Tooooooooooo complex to explain in here :D check pic.

OLAP vs OLTP Systems?
OLAP stands for Online Analytic Processing - Allows analyze multiple database at one time
OLTP mean Online Transaction Processing

OLAP				OLTP 
Analytical			Transactional
Slow Queries		Fast processing
Denormalized		Normalized
Histrorical Data	Current data

OLAP Cube?
It's a datastructre provide to fast analyze data according to multiple dimensions. 
Names of dimensions are coming from knowledge, for ex, years - names - columns

STAR Schema (Datawarehouse)
For example we created one table as main table and  other tables have relations with main table.
Like spider web. Remember sql project. Middle one is star table/ main table.

ETL & SSIS
ETL system -> we get some info from one machine(source) and convert to anther source. Extract -> Transform -> Load
SSIS system -> check from lms please :D 

TYPES OF DATA MODELS 
(Not too important know all of them. Only we will see *Relational* one -> it's my comment btw :D )
Flat Model			-> A flat-file database is a database stored in a file called a flat file. Records follow a uniform format, 
					   and there are no structures for indexing or recognizing relationships between records. The file is simple. 
					   A flat file can be a plain text file, or a binary file.
Network Model		-> Designed flexible approach to represent object and their relationalship.
Object-oriented		-> Data and their relationships are contained in a single structure. bla bla bla
Hierarchical Model	-> is a model in which lower levels are sorted under a hierarchy of successively higher-level units. 
					   Data is grouped into clusters at one or more levelsFor ex, we have parent and they have children 
					   and represent their children and children represent their children(grand children) like family tree
Relational Model	-> This is the trend one cause it prevents data redundancy and you can make relations between different tables,
					   also hey provide multiple user work at same data at same time bla bla bla etc.
NoSQL Model			-> provides a mechanism for storage and retrieval of data (big data and real-time web applications) worth to google

NOSQL DATABASE
Big Data (will be good if you check from web)

Vertical - Horizontal Scaling
Other name of vertical scaling is scale-up -> you can start with your current set-up but improve on it by adding more features 
and upgrading ...
Other name of horizontal scaling is scale-out -> basically copy and paste your current setu, don't improve specifications, just
adding more machine on horizontal to improve your specs or speed.

Comparing NoSQL Databases and Relational Databases
				NoSQL					Relational
Performance		High					Low
Reliability		Poor					Good
Availability	Good					Good
Consistency		Poor					Good
Data Storage	Optimize for Huge data	Medium size -> to large
Scalability		Hþgh					High (but more expensive)

Entity - Relationship Model
Composed of entity types (which classify the things) and relationships (between entities)
Relation between two tables or two entites

			--> DATABASE USERS <--

-End Users:
People whose jobs require access to a database for querying, updating and generating reports.
Which people use computer, phone smth like that means these users are end users
-Application Users:
The people who access an existing application program to perform daily tast.
-Sophisticated Users:
Who have their own way of accessing the database.
-Application Programmers:
Ýmplement specific app programs to access the stored data. Familiar with the DBMS.
-Database Administrators (DBA)
One person or group of people. Responsible for lots of thing :D 

DBA Responsibilities
-Installing and upgrading the DBMS Servers.
-Design and implementation.
-Performance tuning.
-Migrate database servers
-Backup and Recovery.
-Security
-Documentation

			--> RELATIONAL DATA MODEL CONCEPTS <--

We use 'Entity Relationship Diagrams(ER)' this diagram is widely used to design relational databases.
Entities are becoming table inside ER schema. They can be used to visualize database tables.

What is Relational Data Model?
This model describes the word as 'a collection of interrrelated relations(or tables)'

What is Relation?
Also known as a Table or File / Subset of Cartesian product
For ex: region_id is relation between region and countries table.

What is Table?
Database comprised of multiple tables -> Tables holds the data.

Columns
The principle storage units are called columns

Domain
Domain is the original sets of atomic values. These are used to model data.
'THE ATOMIC VALUE' is an instance of one of the built-in atomic data types that are defined by XML Schema. 
These data types include strings, integers, decimals, dates, and other atomic types. 
These types are described as atomic because they cannot be subdivided. Unlike nodes, atomic values do not have an identity.
For ex: The domain of Marital Status are should be 'Married', 'single' or 'divorced'

Record
Contain fields that are related, such as a customer or an employee. Aka. Tuple

Table Properties of Relational Database
-Unique names
-No duplicated rows, each row is distinct
-Entries are atomic (in column)
-Entries are from same domain (related with their data type including)
	--number
	--character
	--date
	--logical
-Operation with different data types are disallowed
-Attributes have unique names

Keys
Keys are most important part of Relational database models.
Keys identify relationships between tables
Can be single or group of attributes
	--Candidate key
	--Composite key
	--Primary key (PK) not movie one :D --> can not be null
	--Secondary key
	--Alternate key
	--Foreign key (FK) not Free kick or First kiss or Flash kitt or French kiss :D --< can be null
	Note: Fk and Pk must be of the same dtype.

			--> CARDINALITY AND CONNECTIVITY <--

Relationship
We have different types of relationships like 1:1, 1:M, M:M, Unary, Ternary

Types of RelationShips
-Ýmportant to understand
-Differences are not technical --> logical-semantic connection between two tables
-We have different types = 1:1, 1:M, M:M, Unary, Ternary

1:1 One to One Relationship
One entity set A ->to<- only one entity set B
For ex: One person has 1 passport

1:M One to Many Relationship
One entity from entity set A can be associated with more than one entity from entity set B
For ex: One customer has or get or place many orders, but these orders go to one (desired) customer
Another ex: One country has many cities :D Thanks to @Leon-Instructor :D

M:N Many to Many Relationship
One entity from entity set A can be associated with more than one (+1) entity from entity set B and vice versa. 
It cannot be implemented as such in the relational model. It can be implemented by breaking up to produce a set of 1M
relationships.
We need to create one more common/bridge table and we need to convert it to many to many relation table
For ex: even if i did not understand clearly :D but we can handle at hands-on session :D
		One or more students has one or more projects / one or more projects can be done by one or more students. 

Unary Relationship (recursive-repetitive)
Also called recursive.
Primary and foreign keys are the same. 
For ex: Thnk about the staffs of one company. All of them have different roles and these roles' relationship can be
exist between same entity set. More clearly, one employee can be manager or supervisor and subworker also.

Ternary RelationShip
That relationship type involves M:N relationships between thre tables
We don't use too much but good to know for interviews :D 

			--> ENTITY RELATIONSHIP DIAGRAM <--

It's avivual representation of different entities within a sysytem and how reate to each other.
For ex: writer, novel and a consumer tables. These may be described using ER diagrams by following:

		Writer  --->  Creates  --->  Novel
										|
										|
										v
		Consumer  ----------------->  Buys

ER Diagrams Notations (showings)
-Chen's notation (One-to-one (1:1), One-to-many (1:N), Many-to-one (N:1), Many-to-many (M:N))
-Crow's foot notation (One, Many, Zero or many, One or many, One and only one, Zero or one)
Chen and Crow’s Foot notation use different approaches to represent relationships. Some people prefer one over the other, 
but they ultimately show the same information.
Chen notation uses a diamond and connecting lines with symbols to describe relationship and cardinality, 
while Crow’s Foot just uses lines with symbols on the end. Cardinality is essential for showing the numerical relationship 
between entities.

Entity
Entity is an object and mghy be physical(lecturer, student, car) or conceptual(course, job, position)

Entity's Strength
-Strong Entity type:
A strong entity is not dependent of any other entity in the schema. A strong entity will always have a primary key. 
Strong entities are represented by a single rectangle. 
-Weak Entity:
A weak entity is dependent on a strong entity to ensure the its existence. Unlike a strong entity, a weak entity 
does not have any primary key. It instead has a partial discriminator key. A weak entity is represented by a double rectangle.

Attributes
an attribute refers to a database component, such as a table. 
It also may refer to a database field. Attributes describe the instances in the column of a database.

			--> HOW TO DROW ER DIAGRAM <--

-Identify all the entities
-Identify relationship
-Add attributes

			--> INTEGRITY RULES AND CONSTRAINTS <--

Domain Integrity
Domain integrity encompasses rules and other processes that restrict the format, type, and volume of data recorded in a database. 
It ensures that every column in a relational database is in a defined domain.

Entity Integrity
Entity integrity is concerned with ensuring that each row of a table has a unique and non-null primary key value; 
this is the same as saying that each row in a table represents a single instance of the entity type modelled by the table.

Null
Special symbol, independent data type means either unknown or inapplicable. Not mean zero or blank.
-Unknown attribute value
-Known, but missing, attribute value
-'not applicable' condition

Referential Integrity
A foreign key must have a matching pk or it must be null.
A reference from a row in one table to another table must be valid.
Additional FK rules may be added such as what to do with child rows when the record with the pk. ...

Enterprise Constraints
Aka semantic constraints
Additional rules defined by users or DBA and can be based on muþtiple tables

Business Rules
Obtained from users when gathering requirements
For ex: A teacher can each many students
		A class can have a maximum of 35 students.
		A course can be taught many times, but by only one instructor.
		Not all teachers teach classes.
           
--------- DATABASE MODELLING AND DESIGN - SESSION 1 (11.08.2021) -------------
																				*/