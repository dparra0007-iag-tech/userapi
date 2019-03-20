const {
    BatchRecorder,
    jsonEncoder: {JSON_V2}
  } = require('zipkin');
  const {HttpLogger} = require('zipkin-transport-http');
  
  // Send spans to Zipkin asynchronously over HTTP
  const zipkinBaseUrl = process.env.OPENTRACING_BASEURL;
  const recorder = new BatchRecorder({
    logger: new HttpLogger({
      endpoint: `${zipkinBaseUrl}/api/v2/spans`,
      jsonEncoder: JSON_V2
    })
  });
  
  module.exports.recorder = recorder;