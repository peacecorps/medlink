angular.module('medSupplies', [
  'ngResource'
  'medSupplies.services'
  'medSupplies.filters'
  'medSupplies.directives'
  'medSupplies.controllers'
])

.config([
  '$routeProvider',
  '$locationProvider',

  ($routeProvider, $locationProvider) ->
    $routeProvider

    .when('/',
      templateUrl: '/assets/templates/main.html'
      controller: 'MainCtrl'
    )

    $locationProvider.html5Mode(true);
])