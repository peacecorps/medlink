angular.module('medSupplies.controllers')

.controller('OrderShowCtrl', [
  '$scope',
  '$routeParams',
  '$location',
  'Order',
  'Supply',

  ($scope, $routeParams, $location, Order) ->
    $scope.order = Order.get({id: $routeParams.id}).then (u) ->
      console.log u
])