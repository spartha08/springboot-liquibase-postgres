# Springboot Application with Postgres and Liquibase
About the setup. This is a bare minimum Springboot application. The purpose of this project is to demonstrate using Liquibase with Postgres and Springboot. There are multiple ways of integrating Liquibase. Here we embed Liquibase into the SpringBoot application. 
## Setting up Postgres
### Installation
* Postgres can be setup as a `docker-compose` service. Go down this line, if Postgres is not setup already.
* Install [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/). Run the command below to start Postgres on ```localhost:6432```
```bash
docker-compose up -d liquibase_db
```
* Modify ```docker-compose.yml``` to use a different port.
### Preparing the DB
* Log in using ```psql```. If using ```docker``` run the following command
```bash
docker exec -it `docker-compose ps -q liquibase_db` psql -U postgres postgres
```
OR (Assuming that ```postgres``` is installed on the host. Suitably modify the command otherwise.)
```bash
psql -h localhost -p 5432 -U postgres postgres
```
On Prompt create the new DB to be used for this demo.
```psql
CREATE DATABASE indexer;
```


## Setting Spring Boot application
[Spring Initializer](https://start.spring.io/) was used to create the SpringBoot project.
### Application Propertes
```
spring.datasource.url=jdbc:postgresql://localhost:6432/indexer
spring.datasource.username=postgres
spring.datasource.password=postgres
```
```Liquibase``` will use these settings to connect to the migrate database . Alternatively, following properties can also be used
```
spring.liquibase.url=jdbc:postgresql://localhost:6432/indexer
spring.liquibase.user=postgres
spring.liquibase.password=postgres
```
The next couple of properties are related to Postgres.
```
spring.datasource.driver-class-name = org.postgresql.Driver
spring.jpa.properties.hibernate.dialect = org.hibernate.dialect.PostgreSQLDialect
```
It is important to disable hibernate/JPA from generating/updating schema. This would be handled by ```Liquibase``` 
```
spring.jpa.hibernate.ddl-auto=none
```
Define the path where ```Liquibase``` will find the ChangeLog root document. Supported format include ```json, yaml and xml```. This will include all the ChangeSets (Migrations) in the DB
```
spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.xml
```
```
logging.level.liquibase = INFO
```
### Understanding Liquibase Migrations
1. Setting up ChangeLog for Liquibase
2. ChangeLog Format
3. Generating ChangeLog from existing DB
##### Using SQL for writing Migration files
##### Rollback Strategy

## Setting up Gradle for Liquibase
???

## References
- [https://www.liquibase.org/blog/3-ways-to-run-liquibase](https://www.liquibase.org/blog/3-ways-to-run-liquibase)
