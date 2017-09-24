do ->

  config = ($stateProvider, $urlRouterProvider) ->
    # default route
    $urlRouterProvider.otherwise '/'
    $stateProvider.state('home',
      url: '/'
      templateUrl: 'home/index.html'
      controller: 'Home.IndexController'
      controllerAs: 'vm'
      data: activeTab: 'home').state 'account',
      url: '/account'
      templateUrl: 'account/index.html'
      controller: 'Account.IndexController'
      controllerAs: 'vm'
      data: activeTab: 'account'
    return

  run = ($http, $rootScope, $window) ->
    # add JWT token as default auth header
    $http.defaults.headers.common['Authorization'] = 'Bearer ' + $window.jwtToken
    # update active tab on state change
    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      $rootScope.activeTab = toState.data.activeTab
      return
    return

  'use strict'
  angular.module('app', [ 'ui.router' ]).config(config).run run
  # manually bootstrap angular after the JWT token is retrieved from the server
  $ ->
    # get JWT token from server
    $.get '/app/token', (token) ->
      window.jwtToken = token
      angular.bootstrap document, [ 'app' ]
      return
    return
  return