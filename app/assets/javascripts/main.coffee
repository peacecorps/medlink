angular.module('rhok',
  'ngResource'
  'rhok.services'
  'rhok.filters'
  'rhok.directives'
  'rhok.controllers'
)

.config([
  '$routeProvider',
  '$locationProvider',

  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/')
])