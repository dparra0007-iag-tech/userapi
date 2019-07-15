#!/bin/bash
set -e 

sleep 30

newman run https://www.getpostman.com/collections/f685e5d789063b1093f8 --reporters cli,junit --reporter-junit-export outputfile.xml --environment https://api.getpostman.com/environments/651996-b80ed237-9179-35ec-d8a1-35d574e118c8?apikey=100822fe2bd7454eb916c8ebdd4be266

sed -i -e 's/<testcase/<testcase classname=\"CI\"/g' outputfile.xml

export token=$(curl -H "Content-Type: application/json" -X POST --data "{ \"client_id\": \"$JIRA_CLIENT_ID\",\"client_secret\": \"$JIRA_SECRET_ID\" }" https://xray.cloud.xpand-it.com/api/v1/authenticate| tr -d '"')

curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token" --data @"outputfile.xml" https://xray.cloud.xpand-it.com/api/v1/import/execution/junit?testExecKey=$XRAY_FUNC_TEST