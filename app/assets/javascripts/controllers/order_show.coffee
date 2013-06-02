angular.module('medSupplies.controllers')

.controller('OrderShowCtrl', [
  '$scope',
  '$routeParams',
  '$location',
  'Order',
  'Supply',

  ($scope, $routeParams, $location, Order) ->
    $scope.messages = [
      'Your request is estimated to arrive at your location on this date.'
      'We do not have your requested item in stock please purchase elsewhere and allow us to reimburse you.'
      'Please pick up your request at this by this date.'
      'Please contact me at this concerning your request.'
    ]

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

    $scope.$watch 'orderAction', (newValue) ->
      message = $scope.messages[newValue]
      if (message)
        $scope.order.instructions = message
      else
        $scope.order.instructions = ''
])