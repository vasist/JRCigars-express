(function() {
  var Service;
  Service = function($rootScope) {
    var Error, Success, initService, service;
    service = {};
    initService = function() {
      var clearFlashMessage;
      clearFlashMessage = function() {
        var flash;
        flash = $rootScope.flash;
        if (flash) {
          if (!flash.keepAfterLocationChange) {
            delete $rootScope.flash;
          } else {
            flash.keepAfterLocationChange = false;
          }
        }
      };
      $rootScope.$on('$locationChangeStart', function() {
        clearFlashMessage();
      });
    };
    Success = function(message, keepAfterLocationChange) {
      $rootScope.flash = {
        message: message,
        type: 'success',
        keepAfterLocationChange: keepAfterLocationChange
      };
    };
    Error = function(message, keepAfterLocationChange) {
      $rootScope.flash = {
        message: message,
        type: 'danger',
        keepAfterLocationChange: keepAfterLocationChange
      };
    };
    service.Success = Success;
    service.Error = Error;
    initService();
    return service;
  };
  'use strict';
  angular.module('app').factory('FlashService', Service);
})();
