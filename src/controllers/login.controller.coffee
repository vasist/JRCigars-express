express = require('express')
router = express.Router()
request = require('request')
config = require('../config.json')
router.get '/', (req, res) ->
  delete req.session.token
  viewData = success: req.session.success
  delete req.session.success
  res.render 'login', viewData
  return
router.post '/', (req, res) ->
  request.post {
    url: config.apiUrl + '/users/authenticate'
    form: req.body
    json: true
  }, (error, response, body) ->
    if error
      return res.render('login', error: 'An error occurred')
    if !body.token
      return res.render('login',
        error: body
        username: req.body.username)
    req.session.token = body.token
    returnUrl = req.query.returnUrl and decodeURIComponent(req.query.returnUrl) or '/'
    res.redirect returnUrl
    return
  return
module.exports = router