do ->

  Service = ($rootScope) ->
    service = {}

    initService = ->

      clearFlashMessage = ->
        flash = $rootScope.flash
        if flash
          if !flash.keepAfterLocationChange
            delete $rootScope.flash
          else
            # only keep for a single location change
            flash.keepAfterLocationChange = false
        return

      $rootScope.$on '$locationChangeStart', ->
        clearFlashMessage()
        return
      return

    Success = (message, keepAfterLocationChange) ->
      $rootScope.flash =
        message: message
        type: 'success'
        keepAfterLocationChange: keepAfterLocationChange
      return

    Error = (message, keepAfterLocationChange) ->
      $rootScope.flash =
        message: message
        type: 'danger'
        keepAfterLocationChange: keepAfterLocationChange
      return

    service.Success = Success
    service.Error = Error
    initService()
    service

  'use strict'
  angular.module('app').factory 'FlashService', Service
  return

