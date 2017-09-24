do ->

  Controller = ($window, UserService, FlashService) ->
    vm = this

    initController = ->
      # get current user
      UserService.GetCurrent().then (user) ->
        vm.user = user
        return
      return

    saveUser = ->
      UserService.Update(vm.user).then(->
        FlashService.Success 'User updated'
        return
      ).catch (error) ->
        FlashService.Error error
        return
      return

    deleteUser = ->
      UserService.Delete(vm.user._id).then(->
        # log user out
        $window.location = '/login'
        return
      ).catch (error) ->
        FlashService.Error error
        return
      return

    vm.user = null
    vm.saveUser = saveUser
    vm.deleteUser = deleteUser
    initController()
    return

  'use strict'
  angular.module('app').controller 'Account.IndexController', Controller
  return

