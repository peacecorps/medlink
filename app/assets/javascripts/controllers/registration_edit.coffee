angular.module('medSupplies.controllers')

.controller('RegistrationEditCtrl', [
  '$scope',
  '$location',
  '$http',
  'CurrentUser',
  'UserRegistration',

  ($scope, $location, $http, CurrentUser, UserRegistration) ->
    CurrentUser.get {}, (user) ->
      $scope.user = new UserRegistration(user)

    $scope.updateUser = ->
      $scope.user.save().then(
        (res) ->
          console.log res
          $scope.$emit 'auth:update'
          $scope.$emit 'flash:add', 'Successfully updated your profile.'
          $location.path '/'
        (e) ->
          console.log e
          $scope.$emit 'flash:add', 'There was a problem with your profile.'
      )
])