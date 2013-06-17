angular.module('medSupplies.controllers')

.controller('RegistrationNewCtrl', [
  '$scope',
  '$location',
  '$http',
  'UserRegistration',

  ($scope, $location, $http, UserRegistration) ->
    $scope.user = new UserRegistration()

    $scope.createUser = ->
      $scope.user.create().then(
        (res) ->
          $scope.$emit 'flash:add', 'Welcome! Please sign in with your new account.'
          $location.path '/users/sign_in'
        (e) ->
          console.log e
          $scope.$emit 'flash:add', 'There was a problem with your information.'
      )
])