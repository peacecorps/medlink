angular.module('medSupplies.controllers')

.controller('OrderNewCtrl', [
  '$scope',
  '$location',
  'Order',
  'Supply',

  ($scope, $location, Order, Supply) ->
    $scope.supplies = Supply.query()
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

    $scope.order =
      requestsAttributes: []
      extra: ''

    $scope.addRequest = ->
      $scope.order.requestsAttributes.push
        supplyId: ''
        dosageValue: ''
        dosageUnits: ''
        quantity: ''

    $scope.submitOrder = ->
      orderData = angular.copy($scope.order)
      angular.forEach orderData.requestsAttributes, (req) ->
        req.dose = req.dosageValue + req.dosageUnits
        delete req.dosageValue
        delete req.dosageUnits
      order = new Order(orderData).create().then (results) ->
        # display success
        $location.path('/')
      , (error) ->
        console.log error

    $scope.addRequest()
])