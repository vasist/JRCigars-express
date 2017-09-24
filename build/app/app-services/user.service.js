(function() {
  var Service;
  Service = function($http, $q) {
    var Create, Delete, GetAll, GetById, GetByUsername, GetCurrent, SaveSearch, Update, getSearch, handleError, handleSuccess, service;
    service = {};
    GetCurrent = function() {
      return $http.get('/api/users/current').then(handleSuccess, handleError);
    };
    GetAll = function() {
      return $http.get('/api/users').then(handleSuccess, handleError);
    };
    GetById = function(_id) {
      return $http.get('/api/users/' + _id).then(handleSuccess, handleError);
    };
    GetByUsername = function(username) {
      return $http.get('/api/users/' + username).then(handleSuccess, handleError);
    };
    SaveSearch = function(obj) {
      return $http.post('/api/users/saveSearch', obj).then(handleSuccess, handleError);
    };
    getSearch = function() {
      return $http.get('/api/users/getSearch').then(handleSuccess, handleError);
    };
    Create = function(user) {
      return $http.post('/api/users', user).then(handleSuccess, handleError);
    };
    Update = function(user) {
      return $http.put('/api/users/' + user._id, user).then(handleSuccess, handleError);
    };
    Delete = function(_id) {
      return $http["delete"]('/api/users/' + _id).then(handleSuccess, handleError);
    };
    handleSuccess = function(res) {
      return res.data;
    };
    handleError = function(res) {
      return $q.reject(res.data);
    };
    service.GetCurrent = GetCurrent;
    service.GetAll = GetAll;
    service.GetById = GetById;
    service.GetByUsername = GetByUsername;
    service.Create = Create;
    service.Update = Update;
    service.Delete = Delete;
    service.SaveSearch = SaveSearch;
    service.getSearch = getSearch;
    return service;
  };
  'use strict';
  angular.module('app').factory('UserService', Service);
})();
