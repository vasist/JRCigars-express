config = require('../../config.json')
express = require('express')
router = express.Router()
userService = require('../../services/user.service')
# routes

saveSearch = (req, res) ->
  userService.saveSearch(req.body).then(->
    res.sendStatus 200
    return
  ).catch (err) ->
    res.status(400).send err
    return
  return

getSearch = (req, res) ->
  userService.getSearch().then((data) ->
    res.send data
    return
  ).catch (err) ->
    res.sendStatus(400).send err
    return
  return

authenticateUser = (req, res) ->
  userService.authenticate(req.body.username, req.body.password).then((token) ->
    if token
      # authentication successful
      res.send token: token
    else
      # authentication failed
      res.status(401).send 'Username or password is incorrect'
    return
  ).catch (err) ->
    res.status(400).send err
    return
  return

registerUser = (req, res) ->
  userService.create(req.body).then(->
    res.sendStatus 200
    return
  ).catch (err) ->
    res.status(400).send err
    return
  return

getCurrentUser = (req, res) ->
  userService.getById(req.user.sub).then((user) ->
    if user
      res.send user
    else
      res.sendStatus 404
    return
  ).catch (err) ->
    res.status(400).send err
    return
  return

updateUser = (req, res) ->
  userId = req.user.sub
  if req.params._id != userId
    # can only update own account
    return res.status(401).send('You can only update your own account')
  userService.update(userId, req.body).then(->
    res.sendStatus 200
    return
  ).catch (err) ->
    res.status(400).send err
    return
  return

deleteUser = (req, res) ->
  userId = req.user.sub
  if req.params._id != userId
    # can only delete own account
    return res.status(401).send('You can only delete your own account')
  userService.delete(userId).then(->
    res.sendStatus 200
    return
  ).catch (err) ->
    res.status(400).send err
    return
  return

router.post '/authenticate', authenticateUser
router.post '/register', registerUser
router.get '/current', getCurrentUser
router.put '/:_id', updateUser
router.delete '/:_id', deleteUser
router.post '/saveSearch', saveSearch
router.get '/getSearch', getSearch
module.exports = router

