var app, bodyParser, config, express, expressJwt, server, session;

require('rootpath')();

express = require('express');

app = express();

session = require('express-session');

bodyParser = require('body-parser');

expressJwt = require('express-jwt');

config = require('./config.json');

app.set('view engine', 'jade');

app.set('views', __dirname + '/views');

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(bodyParser.json());

app.use(session({
  secret: "cigarworld",
  resave: false,
  saveUninitialized: true
}));

app.use(express["static"]('style'));

app.use(express["static"]('config'));

app.use(express["static"]('views'));

app.use('/api', expressJwt({
  secret: config.secret
}).unless({
  path: ['/api/users/authenticate', '/api/users/register']
}));

app.use('/login', require('./controllers/login.controller'));

app.use('/register', require('./controllers/register.controller'));

app.use('/app', require('./controllers/app.controller'));

app.use('/api/users', require('./controllers/api/users.controller'));

app.get('/', function(req, res) {
  return res.redirect('/app');
});

server = app.listen(3000, function() {
  console.log('Server listening at http://' + server.address().address + ':' + server.address().port);
});
