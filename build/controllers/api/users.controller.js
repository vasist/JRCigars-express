var authenticateUser, config, deleteUser, express, getCurrentUser, getSearch, registerUser, router, saveSearch, updateUser, userService;

config = require('../../config.json');

express = require('express');

router = express.Router();

userService = require('../../services/user.service');

saveSearch = function(req, res) {
  userService.saveSearch(req.body).then(function() {
    res.sendStatus(200);
  })["catch"](function(err) {
    res.status(400).send(err);
  });
};

getSearch = function(req, res) {
  userService.getSearch().then(function(data) {
    res.send(data);
  })["catch"](function(err) {
    res.sendStatus(400).send(err);
  });
};

authenticateUser = function(req, res) {
  userService.authenticate(req.body.username, req.body.password).then(function(token) {
    if (token) {
      res.send({
        token: token
      });
    } else {
      res.status(401).send('Username or password is incorrect');
    }
  })["catch"](function(err) {
    res.status(400).send(err);
  });
};

registerUser = function(req, res) {
  userService.create(req.body).then(function() {
    res.sendStatus(200);
  })["catch"](function(err) {
    res.status(400).send(err);
  });
};

getCurrentUser = function(req, res) {
  userService.getById(req.user.sub).then(function(user) {
    if (user) {
      res.send(user);
    } else {
      res.sendStatus(404);
    }
  })["catch"](function(err) {
    res.status(400).send(err);
  });
};

updateUser = function(req, res) {
  var userId;
  userId = req.user.sub;
  if (req.params._id !== userId) {
    return res.status(401).send('You can only update your own account');
  }
  userService.update(userId, req.body).then(function() {
    res.sendStatus(200);
  })["catch"](function(err) {
    res.status(400).send(err);
  });
};

deleteUser = function(req, res) {
  var userId;
  userId = req.user.sub;
  if (req.params._id !== userId) {
    return res.status(401).send('You can only delete your own account');
  }
  userService["delete"](userId).then(function() {
    res.sendStatus(200);
  })["catch"](function(err) {
    res.status(400).send(err);
  });
};

router.post('/authenticate', authenticateUser);

router.post('/register', registerUser);

router.get('/current', getCurrentUser);

router.put('/:_id', updateUser);

router["delete"]('/:_id', deleteUser);

router.post('/saveSearch', saveSearch);

router.get('/getSearch', getSearch);

module.exports = router;
