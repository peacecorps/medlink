angular.module('medSupplies.controllers')

.controller('SessionDestroyCtrl', [
  '$scope',
  '$location',
  '$http',

  ($scope, $location, $http) ->
    $http.delete('/users/sign_out.json')
      .success ->
        $scope.$emit 'auth:destroy'
        $scope.$emit 'flash:add', 'You have been successfully signed out.'
        $location.path '/users/sign_in'
])