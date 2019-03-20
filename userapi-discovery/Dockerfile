FROM iaghcp-docker-technical-architecture.jfrog.io/discovery:1.0.0

COPY src/main/resources/ src/main/resources/

USER 1001

RUN mvn clean package

EXPOSE 8761

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","./target/eureka-0.0.1-SNAPSHOT.jar"]