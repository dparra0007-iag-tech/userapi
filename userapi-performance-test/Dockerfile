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

# ENTRYPOINT ["./test.sh"]