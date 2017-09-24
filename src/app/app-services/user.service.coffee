do ->

  Service = ($http, $q) ->
    service = {}

    GetCurrent = ->
      $http.get('/api/users/current').then handleSuccess, handleError

    GetAll = ->
      $http.get('/api/users').then handleSuccess, handleError

    GetById = (_id) ->
      $http.get('/api/users/' + _id).then handleSuccess, handleError

    GetByUsername = (username) ->
      $http.get('/api/users/' + username).then handleSuccess, handleError

    SaveSearch = (obj) ->
      $http.post('/api/users/saveSearch', obj).then handleSuccess, handleError

    getSearch = ->
      $http.get('/api/users/getSearch').then handleSuccess, handleError

    Create = (user) ->
      $http.post('/api/users', user).then handleSuccess, handleError

    Update = (user) ->
      $http.put('/api/users/' + user._id, user).then handleSuccess, handleError

    Delete = (_id) ->
      $http.delete('/api/users/' + _id).then handleSuccess, handleError

    # private functions

    handleSuccess = (res) ->
      res.data

    handleError = (res) ->
      $q.reject res.data

    service.GetCurrent = GetCurrent
    service.GetAll = GetAll
    service.GetById = GetById
    service.GetByUsername = GetByUsername
    service.Create = Create
    service.Update = Update
    service.Delete = Delete
    service.SaveSearch = SaveSearch
    service.getSearch = getSearch
    service

  'use strict'
  angular.module('app').factory 'UserService', Service
  return

