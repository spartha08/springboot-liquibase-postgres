FROM openjdk:8-jdk-alpine as build
WORKDIR /
COPY src ./src
COPY gradle ./gradle
COPY ./gradlew .
COPY settings.gradle .
COPY build.gradle .
RUN ./gradlew clean build -x test

FROM openjdk:8-jdk-alpine as run
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
WORKDIR /home/spring/
COPY --from=build /build/libs/liquibasedemo-0.0.1-SNAPSHOT.jar ./
RUN  mv ./liquibasedemo-0.0.1-SNAPSHOT.jar ./app.jar
ENTRYPOINT ["java","-jar","app.jar"]
