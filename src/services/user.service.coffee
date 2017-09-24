config = require('../config.json')
_ = require('lodash')
jwt = require('jsonwebtoken')
bcrypt = require('bcryptjs')
Q = require('q')
mongo = require('mongoskin')
db = mongo.db(config.connectionString, native_parser: true)

authenticate = (username, password) ->
  deferred = Q.defer()
  db.users.findOne { username: username }, (err, user) ->
    if err
      deferred.reject err.name + ': ' + err.message
    if user and bcrypt.compareSync(password, user.hash)
      # authentication successful
      deferred.resolve jwt.sign({ sub: user._id }, config.secret)
    else
      # authentication failed
      deferred.resolve()
    return
  deferred.promise

getSearch = ->
  deferred = Q.defer()
  db.search.find().toArray (err, data) ->
    if err
      deferred.reject err
    if data
      deferred.resolve data
    else
      deferred.resolve()
    return
  deferred.promise

getById = (_id) ->
  deferred = Q.defer()
  db.users.findById _id, (err, user) ->
    if err
      deferred.reject err.name + ': ' + err.message
    if user
      # return user (without hashed password)
      deferred.resolve _.omit(user, 'hash')
    else
      # user not found
      deferred.resolve()
    return
  deferred.promise

saveSearch = (obj) ->
  deferred = Q.defer()

  createSearch = (deferred, obj) ->
    db.search.insert obj, (err, doc) ->
      if err
        deferred.reject err
      else
        deferred.resolve()
      return
    return

  db.search.findOne { name: obj.name }, (err, name) ->
    if err
      deferred.reject 'Error in MongoDB'
    else if name
      deferred.reject 'Search already exist'
    else
      createSearch deferred, obj
    return
  deferred.promise

create = (userParam) ->
  deferred = Q.defer()
  # validation

  createUser = ->
    # set user object to userParam without the cleartext password
    user = _.omit(userParam, 'password')
    # add hashed password to user object
    user.hash = bcrypt.hashSync(userParam.password, 10)
    db.users.insert user, (err, doc) ->
      if err
        deferred.reject err.name + ': ' + err.message
      deferred.resolve()
      return
    return

  db.users.findOne { username: userParam.username }, (err, user) ->
    if err
      deferred.reject err.name + ': ' + err.message
    if user
      # username already exists
      deferred.reject 'Username "' + userParam.username + '" is already taken'
    else
      createUser()
    return
  deferred.promise

update = (_id, userParam) ->
  deferred = Q.defer()
  # validation

  updateUser = ->
    # fields to update
    set = 
      firstName: userParam.firstName
      lastName: userParam.lastName
      username: userParam.username
    # update password if it was entered
    if userParam.password
      set.hash = bcrypt.hashSync(userParam.password, 10)
    db.users.update { _id: mongo.helper.toObjectID(_id) }, { $set: set }, (err, doc) ->
      if err
        deferred.reject err.name + ': ' + err.message
      deferred.resolve()
      return
    return

  db.users.findById _id, (err, user) ->
    if err
      deferred.reject err.name + ': ' + err.message
    if user.username != userParam.username
      # username has changed so check if the new username is already taken
      db.users.findOne { username: userParam.username }, (err, user) ->
        if err
          deferred.reject err.name + ': ' + err.message
        if user
          # username already exists
          deferred.reject 'Username "' + req.body.username + '" is already taken'
        else
          updateUser()
        return
    else
      updateUser()
    return
  deferred.promise

_delete = (_id) ->
  deferred = Q.defer()
  db.users.remove { _id: mongo.helper.toObjectID(_id) }, (err) ->
    if err
      deferred.reject err.name + ': ' + err.message
    deferred.resolve()
    return
  deferred.promise

db.bind 'users'
db.bind 'search'
service = {}
service.authenticate = authenticate
service.getById = getById
service.create = create
service.update = update
service.devare = _delete
service.saveSearch = saveSearch
service.getSearch = getSearch
module.exports = service

