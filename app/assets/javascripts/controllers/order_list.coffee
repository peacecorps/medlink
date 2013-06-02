angular.module('medSupplies.controllers')

.controller('OrderListCtrl', [
  '$scope',

  ($scope) ->
    $scope.orders = [
      user: 'Kate Godwin'
      country: 'Uganda'
      hub: 'Center Name'
      supplies: 'Adhesive Tape, Calcium, Sunscreen'
    ,
      user: 'Kate Godwin'
      country: 'Uganda'
      hub: 'Center Name'
      supplies: 'Adhesive Tape, Calcium, Sunscreen'
    ]

])