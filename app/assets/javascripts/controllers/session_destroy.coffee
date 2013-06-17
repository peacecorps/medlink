angular.module('medSupplies.controllers')

.controller('SessionDestroyCtrl', [
  '$scope',
  '$location',
  '$http',
  'UserSession',

  ($scope, $location, $http, UserSession) ->
    $scope.current_user.destroy().then ->
      $scope.$emit 'auth:destroy'
      $scope.$emit 'flash:add', 'You have been successfully signed out.'
      $location.path '/users/sign_in'
])