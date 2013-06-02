angular.module('medSupplies.controllers')

.controller('OrderListCtrl', [
  '$scope',
  'Order',
  'CurrentUser',

  ($scope, Order, CurrentUser) ->
    $scope.orders = Order.query()
])