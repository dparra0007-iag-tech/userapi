# FROM iaghcp-docker-technical-architecture.jfrog.io/taurus:1.1.0

# RUN groupadd -g 1000 username && \
#     adduser --system --uid 1001 --ingroup username username --shell /sbin/nologin --disabled-password && \
#     chown -R 1001:0 /bzt-configs && chmod -R og+rwx /bzt-configs && \
#     chown -R 1001:0 /tmp/artifacts && chmod -R og+rwx /tmp/artifacts

# COPY .bzt-rc /
# RUN  chown -R 1001:0 /.bzt-rc && chmod -R og+rwx /.bzt-rc

# COPY .bzt-rc /home/username/
# RUN  chown -R 1001:0 /home/username/.bzt-rc && chmod -R og+rwx /home/username/.bzt-rc

# ADD test.sh test.sh
# RUN chmod +x ./test.sh

# USER 1001

# COPY ./test.yml /bzt-configs/test.yml

FROM python:3.6.9-alpine3.9

RUN apk add --no-cache make gcc g++ libxml2 libxslt libxslt-dev linux-headers bash curl nodejs nodejs-npm

RUN pip install --upgrade pip wheel psutil setuptools && \
    pip install bzt

RUN mkdir -p /usr/src/app && \
    addgroup -g 1000 -S username && \
    adduser -u 1001 -S username -G username -s /sbin/nologin && \
    chown -R 1001:0 /usr/src/app && chmod -R og+rwx /usr/src/app

COPY .bzt-rc /
RUN  chown -R 1001:0 /.bzt-rc && chmod -R og+rwx /.bzt-rc

WORKDIR /usr/src/app

ADD test.sh test.sh
RUN chmod +x ./test.sh

USER 1001

COPY ./test.yml /bzt-configs/test.yml

ENTRYPOINT ["./test.sh"]