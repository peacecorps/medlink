angular.module('medSupplies.controllers')

.controller('SessionNewCtrl', [
  '$scope',
  '$rootScope'
  '$location',
  '$http',
  'UserSession',

  ($scope, $rootScope, $location, $http, UserSession) ->
    $scope.user = new UserSession()

    $scope.login = ->
      $scope.user.save().then(
        (res) ->
          $scope.$emit 'auth:update', res.user
          $location.path '/'
        (e) ->
          $scope.$emit 'flash:add', 'Invalid email or password.'
      )
])