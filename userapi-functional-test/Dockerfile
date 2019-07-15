FROM iaghcp-docker-technical-architecture.jfrog.io/newman:1.2.0

RUN mkdir -p /usr/src/app && \
    addgroup -g 1000 -S username && \
    adduser -u 1001 -S username -G username -h /usr/src/app -s /sbin/nologin && \
    chown -R 1001:0 /usr/src/app && chmod -R og+rwx /usr/src/app

WORKDIR /usr/src/app

ADD start.sh start.sh
RUN chmod +x ./start.sh

USER 1001

# CMD ["/bin/sh", "-c", "sleep 30 && newman run https://www.getpostman.com/collections/f685e5d789063b1093f8 --reporters cli,junit --reporter-junit-export /var/newman/outputfile.xml --environment https://api.getpostman.com/environments/651996-b80ed237-9179-35ec-d8a1-35d574e118c8?apikey=100822fe2bd7454eb916c8ebdd4be266 && sed -i -e 's/<testcase/<testcase classname=\"CI\"/g' /var/newman/outputfile.xml", 'curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $XRAY_TOKEN" --data @"/var/newman/outputfile.xml" https://xray.cloud.xpand-it.com/api/v1/import/execution/junit?testExecKey=$XRAY_FUNC_TEST']