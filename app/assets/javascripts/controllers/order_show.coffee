angular.module('medSupplies.controllers')

.controller('OrderShowCtrl', [
  '$scope',
  '$routeParams',
  '$location',
  'Order',
  'Supply',

  ($scope, $routeParams, $location, Order) ->
    $scope.order = {}
    Order.get($routeParams.id).then (results) ->
      $scope.order = results

    $scope.saveOrder = ->
      newOrder = angular.copy($scope.order)
      delete newOrder.user
      delete newOrder.requests
      delete newOrder.createdAt
      delete newOrder.updatedAt
      console.log $scope.orderAction

      switch parseInt($scope.orderAction)
        when 0, 1, 2
          newOrder.fulfilled = true

      console.log newOrder
      newOrder.update().then (result) ->
        $location.path('/')
])