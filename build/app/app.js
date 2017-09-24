(function() {
  var config, run;
  config = function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');
    $stateProvider.state('home', {
      url: '/',
      templateUrl: 'home/index.html',
      controller: 'Home.IndexController',
      controllerAs: 'vm',
      data: {
        activeTab: 'home'
      }
    }).state('account', {
      url: '/account',
      templateUrl: 'account/index.html',
      controller: 'Account.IndexController',
      controllerAs: 'vm',
      data: {
        activeTab: 'account'
      }
    });
  };
  run = function($http, $rootScope, $window) {
    $http.defaults.headers.common['Authorization'] = 'Bearer ' + $window.jwtToken;
    $rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {
      $rootScope.activeTab = toState.data.activeTab;
    });
  };
  'use strict';
  angular.module('app', ['ui.router']).config(config).run(run);
  $(function() {
    $.get('/app/token', function(token) {
      window.jwtToken = token;
      angular.bootstrap(document, ['app']);
    });
  });
})();
