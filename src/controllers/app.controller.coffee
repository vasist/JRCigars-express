express = require('express')
router = express.Router()
router.use '/', (req, res, next) ->
  if `req.path != '/login'` and !req.session.token
    return res.redirect('/login?returnUrl=' + encodeURIComponent('/app' + req.path))
  next()
  return
router.get '/token', (req, res) ->
  res.send req.session.token
  return
router.use '/', express.static('app')
module.exports = router