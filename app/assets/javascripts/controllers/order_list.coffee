angular.module('medSupplies.controllers')

.controller('OrderListCtrl', [
  '$scope',
  '$rootScope',
  '$location',
  'Order',

  ($scope, $rootScope, $location, Order) ->
    $scope.orders = Order.query()

    $scope.isAdmin = ->
      $rootScope.current_user?.role == 'admin'

    $scope.viewOrder = (orderId) ->
      $location.path('/orders/' + orderId)

    $scope.unfulfilled = (order) ->
      order.fulfilled == false
])