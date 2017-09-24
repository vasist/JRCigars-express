﻿express = require('express')
router = express.Router()
request = require('request')
config = require('../config.json')
router.get '/', (req, res) ->
  res.render 'register'
  return
router.post '/', (req, res) ->
  # register using api to maintain clean separation between layers
  request.post {
    url: config.apiUrl + '/users/register'
    form: req.body
    json: true
  }, (error, response, body) ->
    if error
      return res.render('register', error: 'An error occurred')
    if response.statusCode != 200
      return res.render('register',
        error: response.body
        firstName: req.body.firstName
        lastName: req.body.lastName
        username: req.body.username)
    # return to login page with success message
    req.session.success = 'Registration successful'
    res.redirect '/login'
  return
module.exports = router
