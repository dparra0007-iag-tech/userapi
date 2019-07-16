FROM iaghcp-docker-technical-architecture.jfrog.io/taurus:1.1.0

RUN groupadd -g 1000 username && \
    adduser --system --uid 1001 --ingroup username username --shell /sbin/nologin --disabled-password && \
    chown -R 1001:0 /bzt-configs && chmod -R og+rwx /bzt-configs && \
    chown -R 1001:0 /tmp/artifacts && chmod -R og+rwx /tmp/artifacts

ADD test.sh test.sh
RUN chmod +x ./test.sh

USER 1001

COPY ./test.yml /bzt-configs/test.yml