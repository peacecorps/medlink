angular.module('medSupplies.controllers')

.controller('SessionNewCtrl', [
  '$scope',
  '$rootScope'
  '$location',
  '$http',

  ($scope, $rootScope, $location, $http) ->
    $scope.user =
      email: null
      password: null

    $scope.login = ->
      $http.post('/users/sign_in.json', {user: $scope.user})
        .success ->
          $location.path '/'
        .error (e) ->
          $scope.$emit 'flash:add', 'Invalid email or password.'
])