angular.module('medSupplies.controllers')

.controller('OrderShowCtrl', [
  '$scope',
  '$rootScope',
  '$routeParams',
  '$location',
  'Order',
  'Supply',

  ($scope, $rootScope, $routeParams, $location, Order) ->
    $rootScope.flash = [] if not $rootScope.flash
    $scope.messages = [
      'Your request is estimated to arrive at your location on this date.'
      'We do not have your requested item in stock. Please purchase elsewhere and allow us to reimburse you.'
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

      switch parseInt($scope.orderAction)
        when 0, 1, 2
          newOrder.fulfilled = true

      newOrder.update().then (result) ->
        $rootScope.flash.push 'Order submitted successfully.'
        $location.path('/')
      , (error) ->
        $rootScope.flash.push 'There was a problem with your order.'


    $scope.$watch 'orderAction', (newValue) ->
      message = $scope.messages[newValue]
      if (message)
        $scope.order.instructions = message
      else
        $scope.order.instructions = ''
])