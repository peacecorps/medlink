angular.module('medSupplies.controllers')

.controller('OrderListCtrl', [
  '$scope',
  '$location',
  'Order',

  ($scope, $location, Order) ->
    $scope.orders = Order.query()

    $scope.viewOrder = (orderId) ->
      $location.path('/orders/' + orderId)
])