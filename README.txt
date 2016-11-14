90-day Data Migration

The Comcast migration project required extensive data mapping, converting and optimizing queries, testing data quality and validating and finally
documenting the entire process in order to produce a manual to act as a guide for users. The first set of sql files are SQL-server queries that
were orignally meant for the local sandbox; GRONK, while the other set are the transformed and optimized queries to be run on the national data 
warehouse (NDW) in the Teradata enviornment to achieve a similar result.

The GRONK consists of only the Northeast Division data whereas the NDW consists of nationwide data. It also has differences in transformation logic 
and fields that may or may not exist in the other. 

Getting Started

In order to run the Sql-Server queries, you will need database software. Here is a list of the free open source options available:
a) SQL-Server Management Studio
b)Mariadb
c)MYSQL

The Teradata files require's the actual software however free trial versions are available online

Running the Query

In order to run the queries, you will need to use you own data while making the appropriate adjustments to the code to denote the actual database,
tables and fields that are being refrenced.

The data for the SQL-Server queries need to essentially be a smaller portion of the data which essentially isolates a portion of data segregated
by region while the complete dataset is where the Teradata queries are run. 

Testing the Query

The tests for the queries involved data quality checks, data validation as well as data consistency.

It also included a component where the time required to run the query was recorded multiple time during different times of the day in order to
identify the most appropriate times to run the queries. This also insured that the Teradata queires were not draining too much computing power
when compared to their SQL-Server counterpart.

Author

Gaurav Chandok - Data Analyst- Migration of the GRONK onto the NDW at COMCAST in MANCHESTER, NH

Acknowledgments

Comcast Employees
Harvey Gish
Joe Femino
Chad Laurent

And the Comcast analysts who wrote the initial queries 
