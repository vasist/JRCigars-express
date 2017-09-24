var config, express, request, router;

express = require('express');

router = express.Router();

request = require('request');

config = require('../config.json');

router.get('/', function(req, res) {
  var viewData;
  delete req.session.token;
  viewData = {
    success: req.session.success
  };
  delete req.session.success;
  res.render('login', viewData);
});

router.post('/', function(req, res) {
  request.post({
    url: config.apiUrl + '/users/authenticate',
    form: req.body,
    json: true
  }, function(error, response, body) {
    var returnUrl;
    if (error) {
      return res.render('login', {
        error: 'An error occurred'
      });
    }
    if (!body.token) {
      return res.render('login', {
        error: body,
        username: req.body.username
      });
    }
    req.session.token = body.token;
    returnUrl = req.query.returnUrl && decodeURIComponent(req.query.returnUrl) || '/';
    res.redirect(returnUrl);
  });
});

module.exports = router;
