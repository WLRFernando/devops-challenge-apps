var express = require('express');
var app = express();
var uuid = require('node-uuid');

var pg = require('pg');
var config = {
  user: process.env.DB_USER,
  host: process.env.DB_HOST ,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: 5432                  //Default port, change it if needed
};

// Routes
app.get('/api/status', function(req, res) {
  const pool = new pg.Pool(config)
  pool.connect(function (err, client, done) {
    if(err) {
      return res.status(500).send('error fetching client from pool');
    }
    console.log(config);
    client.query('SELECT now() as time', function(err, result) {
      //call `done()` to release the client back to the pool
      done();

      if(err) {
        return res.status(500).send('error running query');
      }
      console.log(result);
      return res.json({
        request_uuid: uuid.v4(),
        time: result.rows[0].time
      });
    });
  });
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.json({
    message: err.message,
    error: {}
  });
});


module.exports = app;
