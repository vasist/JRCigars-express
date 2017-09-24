var express;

express = require('express');

module.exports = function(app, config) {
  var home;
  app.configure(function() {
    app.use(express.compress());
    app.use(express["static"](config.publicPath));
    app.set('port', config.port);
    app.set('views', config.viewPath);
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(function(req, res) {
      return res.status(404).render('404', {
        title: '404'
      });
    });
  });
  home = require('../controllers/home');
  return app.get('/', home.index);
};
