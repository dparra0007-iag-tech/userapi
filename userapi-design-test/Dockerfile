FROM iaghcp-docker-technical-architecture.jfrog.io/dredd:1.0.0

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl

RUN mkdir -p /usr/src/app && \
    addgroup -g 1000 -S username && \
    adduser -u 1001 -S username -G username -h /usr/src/app -s /sbin/nologin && \
    chown -R 1001:0 /usr/src/app && chmod -R og+rwx /usr/src/app

WORKDIR /usr/src/app

USER 1001

CMD ["/bin/sh", "-c", "sleep 180 && apiary fetch --api-name=glpuserapi --output=swagger.yaml && dredd ./swagger.yaml http://userapi-apigateway:8080 -r apiary -j apiaryApiKey:bf50f24bdfc3dd2c747dc3c429b2b989 -j apiaryApiName:glpuserapi"]