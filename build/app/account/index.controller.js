(function() {
  var Controller;
  Controller = function($window, UserService, FlashService) {
    var deleteUser, initController, saveUser, vm;
    vm = this;
    initController = function() {
      UserService.GetCurrent().then(function(user) {
        vm.user = user;
      });
    };
    saveUser = function() {
      UserService.Update(vm.user).then(function() {
        FlashService.Success('User updated');
      })["catch"](function(error) {
        FlashService.Error(error);
      });
    };
    deleteUser = function() {
      UserService.Delete(vm.user._id).then(function() {
        $window.location = '/login';
      })["catch"](function(error) {
        FlashService.Error(error);
      });
    };
    vm.user = null;
    vm.saveUser = saveUser;
    vm.deleteUser = deleteUser;
    initController();
  };
  'use strict';
  angular.module('app').controller('Account.IndexController', Controller);
})();
