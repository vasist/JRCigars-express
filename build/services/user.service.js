var Q, authenticate, bcrypt, config, create, db, getById, getSearch, jwt, mongo, saveSearch, service, update, _, _delete;

config = require('../config.json');

_ = require('lodash');

jwt = require('jsonwebtoken');

bcrypt = require('bcryptjs');

Q = require('q');

mongo = require('mongoskin');

db = mongo.db(config.connectionString, {
  native_parser: true
});

authenticate = function(username, password) {
  var deferred;
  deferred = Q.defer();
  db.users.findOne({
    username: username
  }, function(err, user) {
    if (err) {
      deferred.reject(err.name + ': ' + err.message);
    }
    if (user && bcrypt.compareSync(password, user.hash)) {
      deferred.resolve(jwt.sign({
        sub: user._id
      }, config.secret));
    } else {
      deferred.resolve();
    }
  });
  return deferred.promise;
};

getSearch = function() {
  var deferred;
  deferred = Q.defer();
  db.search.find().toArray(function(err, data) {
    if (err) {
      deferred.reject(err);
    }
    if (data) {
      deferred.resolve(data);
    } else {
      deferred.resolve();
    }
  });
  return deferred.promise;
};

getById = function(_id) {
  var deferred;
  deferred = Q.defer();
  db.users.findById(_id, function(err, user) {
    if (err) {
      deferred.reject(err.name + ': ' + err.message);
    }
    if (user) {
      deferred.resolve(_.omit(user, 'hash'));
    } else {
      deferred.resolve();
    }
  });
  return deferred.promise;
};

saveSearch = function(obj) {
  var createSearch, deferred;
  deferred = Q.defer();
  createSearch = function(deferred, obj) {
    db.search.insert(obj, function(err, doc) {
      if (err) {
        deferred.reject(err);
      } else {
        deferred.resolve();
      }
    });
  };
  db.search.findOne({
    name: obj.name
  }, function(err, name) {
    if (err) {
      deferred.reject('Error in MongoDB');
    } else if (name) {
      deferred.reject('Search already exist');
    } else {
      createSearch(deferred, obj);
    }
  });
  return deferred.promise;
};

create = function(userParam) {
  var createUser, deferred;
  deferred = Q.defer();
  createUser = function() {
    var user;
    user = _.omit(userParam, 'password');
    user.hash = bcrypt.hashSync(userParam.password, 10);
    db.users.insert(user, function(err, doc) {
      if (err) {
        deferred.reject(err.name + ': ' + err.message);
      }
      deferred.resolve();
    });
  };
  db.users.findOne({
    username: userParam.username
  }, function(err, user) {
    if (err) {
      deferred.reject(err.name + ': ' + err.message);
    }
    if (user) {
      deferred.reject('Username "' + userParam.username + '" is already taken');
    } else {
      createUser();
    }
  });
  return deferred.promise;
};

update = function(_id, userParam) {
  var deferred, updateUser;
  deferred = Q.defer();
  updateUser = function() {
    var set;
    set = {
      firstName: userParam.firstName,
      lastName: userParam.lastName,
      username: userParam.username
    };
    if (userParam.password) {
      set.hash = bcrypt.hashSync(userParam.password, 10);
    }
    db.users.update({
      _id: mongo.helper.toObjectID(_id)
    }, {
      $set: set
    }, function(err, doc) {
      if (err) {
        deferred.reject(err.name + ': ' + err.message);
      }
      deferred.resolve();
    });
  };
  db.users.findById(_id, function(err, user) {
    if (err) {
      deferred.reject(err.name + ': ' + err.message);
    }
    if (user.username !== userParam.username) {
      db.users.findOne({
        username: userParam.username
      }, function(err, user) {
        if (err) {
          deferred.reject(err.name + ': ' + err.message);
        }
        if (user) {
          deferred.reject('Username "' + req.body.username + '" is already taken');
        } else {
          updateUser();
        }
      });
    } else {
      updateUser();
    }
  });
  return deferred.promise;
};

_delete = function(_id) {
  var deferred;
  deferred = Q.defer();
  db.users.remove({
    _id: mongo.helper.toObjectID(_id)
  }, function(err) {
    if (err) {
      deferred.reject(err.name + ': ' + err.message);
    }
    deferred.resolve();
  });
  return deferred.promise;
};

db.bind('users');

db.bind('search');

service = {};

service.authenticate = authenticate;

service.getById = getById;

service.create = create;

service.update = update;

service.devare = _delete;

service.saveSearch = saveSearch;

service.getSearch = getSearch;

module.exports = service;
