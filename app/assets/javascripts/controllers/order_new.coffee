angular.module('medSupplies.controllers')

.controller('OrderNewCtrl', [
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

    $scope.order =
      requestsAttributes: []
      extra: ''

    $scope.addRequest = ->
      $scope.order.requestsAttributes.push
        supplyId: ''
        dosageValue: ''
        dosageUnits: ''
        unit: ''
        quantity: ''

    $scope.submitOrder = ->
      console.log $scope.order

    $scope.addRequest()
    $scope.units = [
      'mg'
      'mL'
      'g'
      'dL'
      'gr'
      'kg'
      'oz'
      'tbsp'
      'tsp'
      'μg'
    ]
])