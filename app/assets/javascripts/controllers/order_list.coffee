angular.module('medSupplies.controllers')

.controller('OrderListCtrl', [
  '$scope',
  'Order',

  ($scope, Order) ->
    ###
    order = new Order(
      requests_attributes: [
          supply_id: 1
        ,
          supply_id: 2
      ]
    )

    order.create().then (result) ->
      console.log result
    ###

    $scope.orders = Order.query()

])