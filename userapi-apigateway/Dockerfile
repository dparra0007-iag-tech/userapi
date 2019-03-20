FROM iaghcp-docker-technical-architecture.jfrog.io/apigateway:1.0.0

COPY src/main/resources/ src/main/resources/

RUN mvn install -DskipTests

ADD start.sh start.sh
RUN chmod +x ./start.sh

USER 1001

CMD ["mvn package"]

EXPOSE 8080

ENTRYPOINT ["./start.sh"]