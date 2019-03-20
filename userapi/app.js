const express = require('express');

const CLSContext = require('zipkin-context-cls');
const { Tracer } = require('zipkin');
const zipkinMiddleware = require('zipkin-instrumentation-express').expressMiddleware;

const ctxImpl = new CLSContext('zipkin');
const localServiceName = 'userapi';

const path = require('path');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const monk = require('monk');
const { recorder } = require('./recorder');

const tracer = new Tracer({ ctxImpl, recorder, localServiceName });

const db = monk('userapi-db:27017/nodetest2');

const routes = require('./routes/index');

const app = express();

// instrument the server
// const zipkinMiddleware = require('zipkin-instrumentation-express').expressMiddleware;

app.use(zipkinMiddleware({ tracer }));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// logger
app.use(require('express-bunyan-logger')({
  genReqId() {
    return tracer.id;
  },
}));
/* var log = bunyan.createLogger({
  name: 'userapi',
  serializers: { // add serializers for req, res and err
      req: bunyan.stdSerializers.req,
      req: bunyan.stdSerializers.res,
      err: bunyan.stdSerializers.err
  },
  'X-B3-TraceId': tracer.id,
  'X-B3-SpanId': tracer.id
});
var express_logger = log.child({type: 'express', key: value});

app.use(require('express-bunyan-logger')({
  logger: express_logger
})); */

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Make our db accessible to our router
app.use((req, res, next) => {
  req.db = db;
  next();
});

app.use('/userapi/1.0', routes);

// catch 404 and forward to error handler
app.use((req, res, next) => {
  const err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use((err, req, res) => {
    res.status(err.code || 500)
      .json({
        status: 'error',
        message: err,
      });
  });
}

// production error handler
// no stacktraces leaked to user
app.use((err, req, res) => {
  res.status(err.status || 500)
    .json({
      status: 'error',
      message: err.message,
    });
});


module.exports = app;
