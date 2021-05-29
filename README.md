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
On prompt for a password, set password as ```postgres``` (This sets the password for the postgres DB. Whatever is set should be remembered!)
On Prompt create the new DB to be used for this demo.
```psql
CREATE DATABASE index;
CREATE ROLE indexer;
# liquibase expects a role with login capability
ALTER ROLE indexer WITH LOGIN;
GRANT ALL PRIVILEGES on database "index" to "indexer";
```


## Setting Spring Boot application
[Spring Initializer](https://start.spring.io/) was used to create the SpringBoot project.
### Application Propertes
```Liquibase``` will use these settings to connect to the migrate database.
```
spring.datasource.url=jdbc:postgresql://localhost:6432/indexer
spring.datasource.username=postgres
spring.datasource.password=postgres
```
Alternatively, following properties can also be used
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
Define the path where ```Liquibase``` will find the ChangeLog root document. Supported formats include ```json, yaml, sql and xml```. This will include all the ChangeSets (Migrations) in the DB
```
spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.xml
```
### Understanding Liquibase Migrations
- Generating ChangeLog from an existing Database. Install ```liquibase-cli``` from [here](https://www.liquibase.org/download)
```
liquibase --url jdbc:postgresql:<Your-DB> --changeLogFile=db.changelog-master.xml --username=<Username> --password=<Password> generateChangeLog
```
- ChangeLog Format

Read about ChangeLog Format from [Here](https://docs.liquibase.com/concepts/basic/changelog.html). This project uses XML and SQL to record and play migrations.

#### Rollback Strategy
Rollback Strategy is not Straight forward. There are 2 approaches
- If DB is accessible directly
  then use ```liquibase-cli``` OR Gradle ```Liquibase``` plugin to do a rollback.
- If not, **implement a new Changeset with the rollback commands**. Let the embedded ```liquibase``` complete the rollback as a changeset  

## Running the application
```bash
./gradlew bootRun
```
This should start the SpringBoot application and complete the migrations. Log into Postgres to check if the database has been migrated.

## References
- [https://www.liquibase.org/blog/3-ways-to-run-liquibase](https://www.liquibase.org/blog/3-ways-to-run-liquibase)
- [https://docs.liquibase.com/tools-integrations/springboot/springboot.html](https://docs.liquibase.com/tools-integrations/springboot/springboot.html)
- [Liquibase Gradle Plugin](https://plugins.gradle.org/plugin/org.liquibase.gradle)
